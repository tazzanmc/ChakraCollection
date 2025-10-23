SMODS.Joker{ -- Spawn common, uncommon, rare, negative, ethereal jokers
    key = 'e10+', --joker key
    loc_txt = { -- local text
        name = 'E10+',
        text = {
            "{C:attention}Retrigger{} played {C:attention}non-face{} cards",
            "which score for {C:chips}10{} or more Chips"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 7, y = 5},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pixel_size = { w = 62 },
    config = {
        extra = {
            repetitions = 1
        }
    },
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:get_chip_bonus() >= 10 and not context.other_card:is_face() then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}