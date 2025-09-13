SMODS.Joker{ -- +$ equal to destroyed joker's rarity
    key = 'death_and_taxes', --joker key
    loc_txt = { -- local text
        name = 'Death & Taxes',
        text = {
          'Earn {C:gold}$#1#{} when selling',
          'a {C:chak_token}Token{} Joker'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 3},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            money = 4,
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self,card,context)
        if context.selling_card and context.cardarea == G.jokers and context.card.config.center.rarity == "chak_Token" then
            return {
                card = card,
                dollars = card.ability.extra.money
            }
        end
    end
}