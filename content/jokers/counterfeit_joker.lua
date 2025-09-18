SMODS.Joker{ -- +$7 if not spend/gain money
    key = 'counterfeit_joker', --joker key
    loc_txt = { -- local text
        name = 'Counterfeit Joker',
        text = {
          'Earn {C:gold}$#1#{} if you leave',
          'a shop {C:attention}without gaining{}',
          '{C:attention}or losing money{}'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 2, y = 0},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            money = 7,
            counterfeit_money = 0,
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self,card,context)
        if context.starting_shop and not context.blueprint then
            card.ability.extra.counterfeit_money = G.GAME.dollars
            return {
                message = "$" .. card.ability.extra.counterfeit_money,
            }
        end
        if context.ending_shop and card.ability.extra.counterfeit_money == G.GAME.dollars then
            return {
                card = card,
                dollars = card.ability.extra.money
            }
        end
    end
}