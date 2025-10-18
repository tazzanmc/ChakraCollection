SMODS.Voucher {
    key = 'restock_plus',
    atlas = 'Vouchers',
    pos = {x = 1, y = 1},
    loc_txt = { -- local text
        name = "Restock Plus",
        text = {
            '{C:attention}Rerolling{} the shop also',
            "rerolls {C:attention}Vouchers",
            "once per shop"
        }
    },
    cost = 10,
    config = {
        extra = {
            rolled = 0
        },
    },
    calculate = function(self, card, context)
        if context.reroll_shop and card.ability.extra.rolled == 0 then
            card.ability.extra.rolled = 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.shop.alignment.offset.y = -5.3
                    G.shop.alignment.offset.x = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        blockable = false,
                        func = function()
                            --play_sound('cardFan2')
                            if #G.shop_vouchers.cards ~= 0 then
                                SMODS.destroy_cards(G.shop_vouchers.cards, true, true, true)
                            end
                            for i=1, G.GAME.starting_params.vouchers_in_shop + (G.GAME.modifiers.extra_vouchers or 0) do
                                local voucher_pool = get_current_pool('Voucher')
                                local selected_voucher = pseudorandom_element(voucher_pool, 'chak_restock')
                                local it = 1
                                while selected_voucher == 'UNAVAILABLE' do
                                    it = it + 1
                                    selected_voucher = pseudorandom_element(voucher_pool, 'chak_restock' .. it)
                                end
                                SMODS.add_voucher_to_shop(selected_voucher)
                            end
                            return true
                        end}))
                    return true
                end
            }))
        end
        if context.ending_shop and card.ability.extra.rolled ~= 0 then
            card.ability.extra.rolled = 0
        end
    end
}