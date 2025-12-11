SMODS.Joker{ -- Spawn common, uncommon, rare, negative, ethereal jokers
    key = 'vending_machine', --joker key
    loc_txt = { -- local text
        name = 'Vending Machine',
        text = {
            "When leaving the shop, lose {C:money}$#1#",
            "and create a {C:attention}Diet Cola{} Joker",
            "{C:inactive}(No duplicates)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 4},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            cost = -4,
            joker_key = "j_diet_cola"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_diet_cola
        return { vars = { card.ability.extra.cost } }
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            local has_cola = false
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.key == card.ability.extra.joker_key then
                    has_cola = true
                end
            end
            if not has_cola then
                SMODS.add_card {
                    area = G.jokers,
                    key = card.ability.extra.joker_key
                }
                return {
                    dollars = card.ability.extra.cost,
                    message = 'Dispensed!',
                    colour = G.C.CHAK_TOKEN
                }
            end
        end
    end
}