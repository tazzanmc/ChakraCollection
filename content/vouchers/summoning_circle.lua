SMODS.Voucher {
    key = 'summoning_circle',
    atlas = 'Vouchers',
    pos = {x = 1, y = 0},
    loc_txt = { -- local text
        name = "Summoning Circle",
        text = {
            'Get a {C:attention}Ghostly Shopper{} tag',
            'at end of round'
        }
    },
    cost = 10,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.tag_chak_ghostly_shopper
    end,
    calculate = function(self, card, context)
        if context.round_eval then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            CHAK_UTIL.add_tag('tag_chak_ghostly_shopper')
                            return true
                        end)
                    }))
                end
            }
        end
    end
}