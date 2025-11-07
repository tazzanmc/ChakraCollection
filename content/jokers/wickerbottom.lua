SMODS.Joker { -- Gain mult for scored Queen. Reset after beating boss
    key = "wickerbottom",
    loc_txt = {
        name = "Wickerbottom",
        text = {
            "Gains {C:mult}+#1#{} Mult when",
            "a {C:attention}Queen{} is scored",
            "{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 6},
    config = {
        extra = {
            mult_gain = 1,
            mult = 0,
            ranks = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 12 and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                card = card,
                colour = G.C.RED,
                message = "Upgraded!"
            }
        end
        if context.joker_main then
            if card.ability.extra.mult ~= 0 then 
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
        if context.cardarea == G.jokers and context.end_of_round and G.GAME.blind:get_type() == "Boss" and not context.blueprint then
            card.ability.extra.mult = 0
            return {
                colour = G.C.FILTER,
                message = "Reset!"
            }
        end
    end
}