SMODS.Joker{ -- xMult per played blind
    key = 'roffle_joker', --joker key
    loc_txt = { -- local text
        name = 'ROFL',
        text = {
            "When {C:attention}Small Blind{} or {C:attention}Big Blind{}",
            "are selected, gain {X:mult,C:white} X#1# {} Mult",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 6, y = 1},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 0.2,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
	end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blind.boss and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.MULT,
				card = card
			}
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                card = card,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}