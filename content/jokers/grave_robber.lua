SMODS.Joker{ -- +$ equal to destroyed joker's rarity
    key = 'grave_robber', --joker key
    loc_txt = { -- local text
        name = 'Grave Robber',
        text = {
          'Earn {C:gold}$X{} when a {C:attention}Joker',
          'is destroyed. {C:gold}X{} is equal',
          "to #1#x Joker's {C:attention}rarity",
          "{C:inactive,s:0.8}({C:blue,s:0.8}Common {C:inactive,s:0.8}= #2#, {C:green,s:0.8}Uncommon {C:inactive,s:0.8}= #3#, etc.)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 6, y = 0},
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
            money = 2,
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.money * 1, card.ability.extra.money * 2 } }
    end,
    calculate = function(self,card,context)
        if context.joker_type_destroyed and context.cardarea == G.jokers then
            if CHAK_UTIL.is_number(context.card.config.center.rarity) then
                card.ability.extra.money = context.card.config.center.rarity
                return {
                    card = card,
                    dollars = card.ability.extra.money
                }
            elseif context.card.config.center.rarity == "chak_Token" then
                return false
            else 
                card.ability.extra.money = 4
                return {
                    card = card,
                    dollars = card.ability.extra.money
                }
            end
        end
    end
}