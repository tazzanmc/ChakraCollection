SMODS.Joker{ -- Retrigger all 7's
    key = 'dragon_balls', --joker key
    loc_txt = { -- local text
        name = 'Wish Orbs',
        text = {
            "Retrigger all {C:attention}7's{}",
            '{C:attention}#1#{} additional times'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = {
        extra = {
            repetitions = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.other_card:get_id() == 7 then
            return {
                card = card,
                message = 'Again!',
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}