SMODS.Joker { -- gain 1 mult for each heart kept. Resets after beating boss
    key = "winona",
    loc_txt = {
        name = "Winona",
        text = {
            "Gains {C:mult}+#1#{} Mult for each",
            "{C:hearts}Heart{} {C:attention}kept{} when discarding",
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
    pos = {x = 3, y = 7},
    config = {
        extra = {
            mult_gain = 1,
            mult = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            local hand_hearts = 0
            local discard_hearts = 0
            for _, playing_card in ipairs(G.hand.cards) do -- Log suits in hand
                if not playing_card.debuff then
                    if playing_card:is_suit("Hearts") then
                        hand_hearts = hand_hearts + 1
                    elseif SMODS.has_any_suit(playing_card) then
                        hand_hearts = hand_hearts + 1
                    end
                end
            end
            for _, playing_card in ipairs(G.hand.highlighted) do -- Log suits in discard
                if not playing_card.debuff then
                    if playing_card:is_suit("Hearts") then
                        discard_hearts = discard_hearts + 1
                    elseif SMODS.has_any_suit(playing_card) then
                        discard_hearts = discard_hearts + 1
                    end
                end
            end
            if hand_hearts - discard_hearts ~= 0 then
                card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_gain * (hand_hearts - discard_hearts))
                return {
                    colour = G.C.MULT,
                    message = "+" .. (card.ability.extra.mult_gain * (hand_hearts - discard_hearts))
                }
            end
        end
        if context.joker_main and card.ability.extra.mult ~= 0 then
            return {
                mult = card.ability.extra.mult
            }
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