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
            SMODS.add_card {
                set = 'Tarot',
                key_append = 'chak_purple_seal' 
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end
}