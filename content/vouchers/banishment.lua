SMODS.Voucher {
    key = 'banishment',
    atlas = 'Vouchers',
    pos = {x = 1, y = 0},
    loc_txt = { -- local text
        name = "Banishment",
        text = {
            'Destroyed {C:attention}Jokers{} no',
            'longer appear'
        }
    },
    cost = 10,
    calculate = function(self, card, context)
        if context.joker_type_destroyed then
            G.GAME.chak.banned_run_keys[context.card.config.center_key] = true
            sendDebugMessage("banned:" .. context.card.config.center_key, "CHAK")
        end
    end
}