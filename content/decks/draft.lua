SMODS.Back { -- Start with booster seat & restock
    key = 'draft',
    loc_txt = {
        name = 'Draft Deck',
        text = {
            "Start with the {C:attention}Booster Seat{}",
            "and {C:attention}Restock{} Vouchers"
        }
    },
    atlas = 'Decks',
    pos = { x = 1, y = 0 },
    config = { 
        vouchers = {
            'v_chak_booster_seat',
            'v_chak_restock'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize { type = 'name_text', key = 'v_chak_booster_seat', set = 'Voucher' },
                localize { type = 'name_text', key = 'v_chak_restock', set = 'paperback_minor_arcana' }
            }
        }
    end
}