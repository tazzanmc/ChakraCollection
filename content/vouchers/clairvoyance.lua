SMODS.Voucher {
    key = 'clairvoyance',
    atlas = 'Vouchers',
    pos = {x = 1, y = 1},
    loc_txt = { -- local text
        name = "Clairvoyance",
        text = {
            '{C:rare}Rare{} {C:attention}Jokers',
            'appear {C:attention}#1#X{} more often'
        }
    },
    requires = {"v_chak_foresight"},
    cost = 10,
    config = {
        extra = {
            increase = 3
        },
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.increase } }
	end,
    redeem = function(self, card)
        card = card,
        G.E_MANAGER:add_event(Event({
            func = function()
                sendDebugMessage("rare original:" .. G.GAME.rare_mod, "CHAK")
                G.GAME.rare_mod = G.GAME.rare_mod * card.ability.extra.increase
                sendDebugMessage("rare new:" .. G.GAME.rare_mod, "CHAK")
                return true
            end
        }))
    end
}