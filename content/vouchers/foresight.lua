SMODS.Voucher {
    key = 'foresight',
    atlas = 'Vouchers',
    pos = {x = 1, y = 0},
    loc_txt = { -- local text
        name = "Foresight",
        text = {
            '{C:uncommon}Uncommon{} {C:attention}Jokers',
            'appear {C:attention}#1#X{} more often'
        }
    },
    cost = 10,
    config = {
        extra = {
            increase = 2
        },
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.increase } }
	end,
    redeem = function(self, card)
        card = card,
        G.E_MANAGER:add_event(Event({
            func = function()
                sendDebugMessage("uncommon original:" .. G.GAME.uncommon_mod, "CHAK")
                G.GAME.uncommon_mod = G.GAME.uncommon_mod * card.ability.extra.increase
                sendDebugMessage("uncommon new:" .. G.GAME.uncommon_mod, "CHAK")
                return true
            end
        }))
    end
}