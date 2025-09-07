SMODS.Joker{ -- +Mult first scored card, upgrades per round
    key = 'poop_butt', --joker key
    loc_txt = { -- local text
        name = 'Poop Butt',
        text = {
          '{C:mult}+#1#{} Mult when scoring',
          '{C:attention}first{} scored card. Gains',
          '{C:mult}+#2#{} Mult per round played'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 0},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            mult = 4,
            mult_gain = 2,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            return {
                card = card,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                colour = G.C.MULT,
                mult_mod = card.ability.extra.mult
            }
        end
        if context.cardarea == G.jokers and context.end_of_round and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain 
            return {
                card = card,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain } },
                colour = G.C.IMPORTANT
            }
        end
    end
}