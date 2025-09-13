SMODS.Joker{ -- Dupe used Spectrals from packs
    key = 'omicron', --joker key
    loc_txt = { -- local text
        name = 'Omicron',
        text = {
          'All {C:chak_sticker_ethereal,E:2}Ethereal{} Jokers',
          'become {C:dark_edition}Negative',
          "{C:inactive}(Except {C:chak_token}Token {C:inactive}Jokers)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 0},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.omicron = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.omicron = false
    end
}