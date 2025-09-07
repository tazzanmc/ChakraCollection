SMODS.Voucher{ -- +1 Booster Pack in Shop
    key = 'drivers_seat',
    atlas = 'Vouchers',
    pos = {x = 0, y = 1},
    loc_txt = { -- local text
        name = "Driver's Seat",
        text = {
            '{C:attention}+1{} Voucher',
            'available in shop'
        }
    },
    requires = {"v_chak_booster_seat"},
    cost = 10,
    config = {
        increase = 1
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.increase } }
	end,
    redeem = function(self, card)
        card = card,
        SMODS.change_voucher_limit(card.ability.increase)
    end
}