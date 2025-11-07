SMODS.Joker { -- Gain mult for hearts in 2nd discard. Reset after beating boss
    key = "wx-78",
    loc_txt = {
        name = "WX-78",
        text = {
            "Gains {C:mult}+#1#{} Mult for each",
            "{C:hearts}Heart{} in your {C:attention}second discard",
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
    pos = {x = 4, y = 6},
    config = {
        extra = {
            mult_gain = 2,
            mult = 0,
            ranks = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 1 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and G.GAME.current_round.discards_used == 1 and context.other_card:is_suit("Hearts") then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
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