SMODS.Consumable {
    key = 'whole',
    loc_txt = {
        name = 'Whole', --name of card
        text = { --text of card
            '{C:red}Destroy{} selected non-{C:dark_edition}Negative',
            'Joker. Create a Joker of',
            '{C:attention}your choice{} of its rarity',
            '{C:inactive}(No duplicates)'
        }
    },
    set = "Spectral",
    atlas = 'Chakras',
    pos = { x = 3, y = 1 },
    soul_pos = {x = 3, y = 2},
    hidden = true,
    soul_set = 'ChakraConsumableType',
    soul_rate = 0.01,
    config = {
        extra = {
            delta = -1,
            jokersselected = 1
            }
        },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.delta }
        }
    end,
    can_use = function(self, card)
        if G and G.jokers then
            if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then
                return not SMODS.is_eternal(G.jokers.highlighted[1], card) and not (G.jokers.highlighted[1].edition and G.jokers.highlighted[1].edition.negative)
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local joker = G.jokers.highlighted[1]
        local rarity = joker.config.center.rarity
        SMODS.destroy_cards(joker)
        CHAK_UTIL.use_consumable_animation(card, nil, function()
            if #G.jokers.cards < G.jokers.config.card_limit + 1 then
                G.SETTINGS.paused = true

                local selectable_jokers = {}

                for _, v in ipairs(G.P_CENTER_POOLS.Joker) do
                -- Only shows discovered common, uncommon or rare and non-owned jokers
                    if v.discovered and not next(SMODS.find_card(v.key)) and (v.rarity == rarity) then
                        selectable_jokers[#selectable_jokers + 1] = v
                    end
                end

                -- If the list of jokers is empty, we want at least one option so the user can leave the menu
                if #selectable_jokers <= 0 then
                    selectable_jokers[#selectable_jokers + 1] = G.P_CENTERS.j_joker
                end

                G.FUNCS.overlay_menu {
                    config = { no_esc = true },
                    definition = CHAK_UTIL.collection_UIBox(
                        selectable_jokers,
                        { 5, 5, 5 },
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
        end)
    end
}