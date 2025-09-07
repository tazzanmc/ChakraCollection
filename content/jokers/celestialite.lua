SMODS.Joker{ -- Dupe skip tags
    key = 'celestialite', --joker key
    loc_txt = { -- local text
        name = 'Celestialite',
        text = {
          'When selecting a {C:attention}Blind{},',
          'get a copy of that',
          "Blind's {C:attention}Skip Tag{}"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 4, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
}