SMODS.Seal{
    key = 'purple_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 1, y = 1 },
    loc_txt = {
        name = 'Purple Joker Seal', --name of card
        label = 'Purple Joker Seal',
        text = { --text of card
            "Create a random {C:tarot}Tarot",
            "{C:tarot}Card{} at end of round",
            "{C:inactive}(Must have room)"
        }
    },
    badge_colour = G.C.PURPLE,
    calculate = function(self, card, context)
        if context.end_of_round and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'chak_purple_seal' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end,
    in_pool = function(self, args)
        return false
    end
}