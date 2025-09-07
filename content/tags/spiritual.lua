SMODS.Tag {
    key = "spiritual",
    atlas = "Tags",
    pos = { x = 1, y = 0 },
    loc_txt = { -- local text
        name = 'Spiritual Tag',
        text = {
                'Gives a free',
                '{C:chak_edition}Mega Chakra Pack{}'
            }
        },
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_chak_chakra_pack_mega
    end,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                CHAK_UTIL.open_booster_pack_from_tag('p_chak_chakra_pack_mega')
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}