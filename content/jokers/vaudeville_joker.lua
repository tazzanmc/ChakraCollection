SMODS.Joker{ -- xMult per played blind
    key = 'vaudeville_joker', --joker key
    loc_txt = { -- local text
        name = 'Vaudeville Joker',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult per {C:chips}#2#{}",
            "Chips in scored hand"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 4},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            Xmult_gain = 1,
            per_chips = 100
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.per_chips } }
	end,
    calculate = function(self, card, context)
        if context.final_scoring_step and math.floor(card.ability.extra.Xmult_gain * (hand_chips / card.ability.extra.per_chips)) > 1 then
            return {
                xmult = math.floor(card.ability.extra.Xmult_gain * (hand_chips / card.ability.extra.per_chips))
            }
        end
    end
}