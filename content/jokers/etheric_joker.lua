CHAK_UTIL.TokenJoker{ -- Always destroyed instead of ethereal
    key = 'etheric_joker', --joker key
    loc_txt = { -- local text
        name = 'Etheric Joker',
        text = {
          'Will be destroyed {C:attention}in',
          '{C:attention}place of{} the next',
          '{C:chak_sticker_ethereal,E:2}Ethereal{} Joker'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 0},
    soul_pos = {x = 3, y = 1},
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
      info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
    end
}