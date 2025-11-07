SMODS.Joker{ -- xMult per played blind
    key = 'the_grill_master', --joker key
    loc_txt = { -- local text
        name = 'The Grill Master',
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when {C:attention}entering",
            "{C:attention}a blind{}. Gives {X:mult,C:white}X#2#{} Mult if chips",
            "scored are below chips required",
            "{C:inactive}(Resets after scoring)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 1},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 1,
            triggered = 0
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
	end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.MULT,
				card = card
			}
        end
        if context.final_scoring_step and (hand_chips * mult < G.GAME.blind.chips) and card.ability.extra.Xmult > 1 then
            card.ability.extra.triggered = 1
            return {
                card = card,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
        if context.after and card.ability.extra.triggered ~= 0 then
            card.ability.extra.triggered = 0
            card.ability.extra.Xmult = 1
            return {
                message = localize('k_reset')
            }
        end
    end
}