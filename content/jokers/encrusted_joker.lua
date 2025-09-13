SMODS.Joker{ -- +$7 if not spend/gain money
    key = 'encrusted_joker', --joker key
    loc_txt = { -- local text
        name = 'Encrusted Joker',
        text = {
          "{C:diamonds}Diamonds{} are",
          "considered {C:attention}Gold{} cards"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 3},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
    end,
    calculate = function(self, card, context)
        if context.check_enhancement and context.other_card.base.suit == "Diamonds" then
            return {
                m_gold = true
            }
        end
    end
}