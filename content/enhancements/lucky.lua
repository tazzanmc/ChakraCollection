SMODS.Enhancement:take_ownership('lucky', 
    { -- Recreated Lucky card from vanillaremade, just with the Certainty clause
        config = { extra = { mult = 20, dollars = 20, mult_odds = 5, dollars_odds = 15 } },
        loc_vars = function(self, info_queue, card)
            local mult_numerator, mult_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds,
                'vremade_lucky_mult')
            local dollars_numerator, dollars_denominator = SMODS.get_probability_vars(card, 1,
                card.ability.extra.dollars_odds, 'vremade_lucky_money')
            return { vars = { mult_numerator, card.ability.extra.mult, mult_denominator, card.ability.extra.dollars, dollars_denominator, dollars_numerator } }
        end,
        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                local ret = {}
                if SMODS.pseudorandom_probability(card, 'vremade_lucky_mult', 1, card.ability.extra.mult_odds) or G.GAME.modifiers.chak_certainty then
                    card.lucky_trigger = true
                    ret.mult = card.ability.extra.mult
                end
                if SMODS.pseudorandom_probability(card, 'vremade_lucky_money', 1, card.ability.extra.dollars_odds) and not G.GAME.modifiers.chak_certainty then
                    card.lucky_trigger = true
                    ret.dollars = card.ability.extra.dollars
                end
                return ret
            end
        end,
    },
    true
)