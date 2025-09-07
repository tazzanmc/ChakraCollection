SMODS.Voucher{ -- +1 Booster Pack in Shop
    key = 'booster_seat',
    atlas = 'Vouchers',
    pos = {x = 0, y = 0},
    loc_txt = { -- local text
        name = 'Booster Seat',
        text = {
            '{C:attention}+1{} Booster Pack',
            'available in shop'
        }
    },
    cost = 10,
    config = {
        increase = 1
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.increase } }
	end,
    redeem = function(self, card)
        card = card,
        SMODS.change_booster_limit(card.ability.increase)
    end
}