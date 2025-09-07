SMODS.Consumable{ -- Destroy Joker & open pack
    key = 'heart_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    atlas = 'Chakras', --atlas
    pos = {x = 3, y = 0}, --position in atlas
    loc_txt = {
        name = 'Heart', --name of card
        text = { --text of card
            '{C:red}Destroy{} {C:attention}#1#{} selected non-{C:dark_edition}Negative',
            'Joker and {C:attention}choose{} between',
            '{C:attention}#2#{} random Jokers',
            '{C:inactive}(No Legendary Jokers)'
        }
    },
    config = {
        extra = {
            jokersselected = 1, --configurable value
            randomjokers = 2
        }
    },
    loc_vars = function(self,info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return {vars = {card.ability.extra.jokersselected, card.ability.extra.randomjokers}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        if G and G.jokers then
            if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then
                return not SMODS.is_eternal(G.jokers.highlighted[1], card) and not (G.jokers.highlighted[1].edition and G.jokers.highlighted[1].edition.negative)
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.jokers.highlighted do
            CHAK_UTIL.use_consumable_animation(card, nil, function()
                    local joker = G.jokers.highlighted[i]
                    joker:juice_up()
                    SMODS.destroy_cards(joker)
                    if #G.jokers.cards < G.jokers.config.card_limit + 1 then
                        G.SETTINGS.paused = true

                        local selectable_jokers = {}

                        for _, v in ipairs(G.P_CENTER_POOLS.Joker) do
                        -- Iterate over jokers
                            if v.discovered and not next(SMODS.find_card(v.key)) and v.rarity ~= 4 then
                                selectable_jokers[#selectable_jokers + 1] = v
                            end
                        end

                        -- If the list of jokers is empty, we want at least one option so the user can leave the menu
                        if #selectable_jokers <= 0 then
                            selectable_jokers[#selectable_jokers + 1] = G.P_CENTERS.j_joker
                        end

                        local j = card.ability.extra.randomjokers
                        local random_jokers = {}
                        for i = 1, j do
                            random_jokers[#random_jokers + 1] = pseudorandom_element(selectable_jokers, pseudoseed('chak_heart_chakra'))
                        end

                        G.FUNCS.overlay_menu {
                            config = { no_esc = true },
                            definition = CHAK_UTIL.collection_UIBox(
                                random_jokers,
                                {j},
                                {
                                    no_materialize = true,
                                    modify_card = function(other_card, center)
                                        other_card.sticker = get_joker_win_sticker(center)
                                        CHAK_UTIL.create_select_card_ui(other_card, G.jokers)
                                    end,
                                    h_mod = 1.05,
                                }
                            ),
                        }
                    end
                end
            )
        end
    end
}