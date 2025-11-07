SMODS.Joker { -- Gain chips for discarded faces. Reset after beating boss
    key = "willow",
    loc_txt = {
        name = "Willow",
        text = {
            "Gains {C:chips}+#1#{} Chips for",
            "each discarded {C:attention}face card",
            "{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 5,
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 6},
    config = {
        extra = {
            chip_gain = 20,
            chips = 0,
            ranks = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and not context.other_card.debuff and context.other_card:is_face() then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                colour = G.C.BLUE,
                message = "Upgraded!"
            }
        end
        if context.joker_main then
            if card.ability.extra.chips ~= 0 then 
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
        if context.cardarea == G.jokers and context.end_of_round and G.GAME.blind:get_type() == "Boss" and not context.blueprint then
            card.ability.extra.chips = 0
            return {
                colour = G.C.FILTER,
                message = "Reset!"
            }
        end
    end
}