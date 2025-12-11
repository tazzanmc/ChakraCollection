SMODS.Joker { -- Gain chips for Spade in hand. Reset after beating boss
    key = "collectors_edition",
    loc_txt = {
        name = "Collector's Edition",
        text = {
            "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, and {C:dark_edition}Polychrome{}",
            "score on cards {C:attention}held in hand"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 7}
    -- Calc func basically in Hooks
}