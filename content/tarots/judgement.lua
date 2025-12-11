SMODS.Consumable:take_ownership('judgement', 
    { -- Recreated Judgement card from vanillaremade, just with the Hail 2 U clause
        use = function(self, card, area, copier)
            if G.GAME.modifiers.chak_judgement == true then
                CHAK_UTIL.use_consumable_animation(card, nil, function()
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

                        local j = 15
                        local random_jokers = {}
                        for i = 1, j do
                            random_jokers[#random_jokers + 1] = pseudorandom_element(selectable_jokers, pseudoseed('chak_judgement'))
                        end

                        G.FUNCS.overlay_menu {
                            config = { no_esc = true },
                            definition = CHAK_UTIL.collection_UIBox(
                                random_jokers,
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
                end
            )
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Joker' })
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
            end
        delay(0.6)
    end,
    },
    true -- silent | suppresses mod badge
)