SMODS.Joker{ -- +$7 if not spend/gain money
    key = 'last_prism', --joker key
    loc_txt = { -- local text
        name = 'Last Prism',
        text = {
          "{C:attention}Enhanced{} cards are",
          "considered {C:attention}Wild Cards"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 9, y = 0},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    calculate = function(self,card,context)
        if context.check_enhancement and context.other_card.ability.set == "Enhanced" then
            return {
                m_wild = true
            }
        end
    end
}