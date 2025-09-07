SMODS.Tag {
    key = "ghostly_shopper",
    atlas = "Tags",
    pos = { x = 2, y = 0 },
    loc_txt = { -- local text
        name = 'Ghostly Shopper Tag',
        text = {
                'The next shop will have',
                'an additional {C:attention}free',
                '{C:chak_sticker_ethereal}Ethereal Buffoon Pack{}'
        }
    },
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_chak_buffoon_ethereal
    end,
    apply = function(self, tag, context)
        if context.type == 'store_joker_modify' then
            tag:yep('+', G.C.GREEN, function()
                local booster = SMODS.add_booster_to_shop('p_chak_buffoon_ethereal')
                booster.ability.couponed = true
                booster:set_cost()
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}