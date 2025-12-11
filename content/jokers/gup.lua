SMODS.Joker{ -- Spawn Joe Jokers, give mult for each Joker
    key = 'gup', --joker key
    loc_txt = { -- local text
        name = 'Gup',
        text = {
          "Gives {C:white,X:mult}X#1#{} Mult",
          "for each Joker card",
          "{C:attention}Splits{} when sold",
          "{C:inactive}(Currently {C:white,X:mult}X#2# {C:inactive} Mult)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 4},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            joker_key = 'j_chak_geep',
            Xmult_gain = 0.3
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult_gain * (G.jokers and #G.jokers.cards or 0) + 1 } }
    end,
    calculate = function(self,card,context)
        if context.selling_card and context.cardarea == G.jokers and context.card == card and not context.blueprint then
            for i = 1, 2 do
                SMODS.add_card {
                    area = G.jokers,
                    key = card.ability.extra.joker_key,
                    sell_cost = 0
                }
            end
            return {
                message = "Split!",
                colour = G.C.FILTER,
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult_gain * (G.jokers and #G.jokers.cards or 0) + 1
            }
        end
    end
}