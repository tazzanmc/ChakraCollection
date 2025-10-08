SMODS.Voucher {
    key = 'restock',
    atlas = 'Vouchers',
    pos = {x = 1, y = 0},
    loc_txt = { -- local text
        name = "Restock",
        text = {
            '{C:attention}Rerolling{} the shop also',
            "rerolls {C:attention}Booster Packs"
        }
    },
    cost = 10,
    calculate = function(self, card, context)
        if context.reroll_shop then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.shop.alignment.offset.y = -5.3
                    G.shop.alignment.offset.x = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        func = function()
                            --play_sound('cardFan2')
                            if #G.shop_booster.cards ~= 0 then
                                SMODS.destroy_cards(G.shop_booster.cards, true, true, true)
                            end
                            for i=1, G.GAME.starting_params.boosters_in_shop + (G.GAME.modifiers.extra_boosters or 0) do
                                local booster_pool = get_current_pool('Booster')
                                local selected_booster = pseudorandom_element(booster_pool, 'chak_restock')
                                local it = 1
                                while selected_booster == 'UNAVAILABLE' do
                                    it = it + 1
                                    selected_booster = pseudorandom_element(booster_pool, 'chak_restock' .. it)
                                end
                                SMODS.add_booster_to_shop(selected_booster)
                            end
                            return true
                        end}))
                    return true
                end
            }))
        end
    end
}