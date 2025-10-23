SMODS.Voucher {
    key = 'obliteration',
    atlas = 'Vouchers',
    pos = {x = 2, y = 1},
    loc_txt = { -- local text
        name = "Obliteration",
        text = {
            '{C:attention}Destroy{} sold Jokers',
            "{C:inactive,s:0.8}(You still get paid)"
        }
    },
    requires = {"v_chak_banishment"},
    cost = 10,
    calculate = function(self, card, context)
        if context.selling_card then
            SMODS.destroy_cards(card)
        end
    end
}