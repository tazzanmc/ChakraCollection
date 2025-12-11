SMODS.Joker { -- Gain mult for discarded hearts. Reset after beating boss
    key = "maxwell",
    loc_txt = {
        name = "Maxwell",
        text = {
            "Gains {C:mult}+#1#{} Mult for each",
            "discarded {C:hearts}Heart{}",
            "{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 6},
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
        if context.discard and not context.blueprint and context.other_card:is_suit("Hearts") then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                colour = G.C.RED,
                message = "+" .. card.ability.extra.mult_gain
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