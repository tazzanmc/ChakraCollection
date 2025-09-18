SMODS.Voucher{ -- +1 Booster Pack in Shop
    key = '99_slots',
    atlas = 'Vouchers',
    pos = {x = 0, y = 0},
    loc_txt = { -- local text
        name = '99 Slots',
        text = {
            '99 consumable slots'
        }
    },
    cost = 1,
    config = {
        increase = 999
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.increase } }
	end,
    redeem = function(self, card)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.increase
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.increase
    end
}