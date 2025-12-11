SMODS.Joker {
    key = "noisy_joker",
    loc_txt = { -- local text
        name = 'Noisy Joker',
        text = {
          "Played cards with",
          "{C:chak_bells}Bell{} suit give",
          "{C:mult}+#1#{} Mult when scored"
        }
    },
    atlas = "Jokers",
    pos = { x = 1, y = 8 },
    rarity = 1,
    blueprint_compat = true,
    cost = 5,
    config = { extra = { mult = 3, suit = 'chak_Bells' }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.suit, 'suits_singular') } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}