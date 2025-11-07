SMODS.Joker{ -- xMult per played blind
    key = 'JOKE', --joker key
    loc_txt = { -- local text
        name = 'JOKE.',
        text = {
            "nothing yet"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 9, y = 4},
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
    end,
    in_pool = function(self, args) -- Don't appear
        return false
    end
}