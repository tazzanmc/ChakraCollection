SMODS.Joker { -- Gain chips if you discard hand > high card. Reset after beating boss
    key = "wes",
    loc_txt = {
        name = "Wes",
        text = {
            "Gains {C:chips}+#1#{} Chips if you discard",
            "a hand better than {C:attention}High Card{}",
            "{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'Jokers', --atlas' key
    pos = {x = 7, y = 6},
    config = {
        extra = {
            chip_gain = 30,
            chips = 0,
            og_hand = ""
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            if G.FUNCS.get_poker_hand_info(G.hand.highlighted) ~= "High Card" then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    colour = G.C.BLUE,
                    message = "Upgraded!"
                }
            end
        end
        if context.joker_main and card.ability.extra.chips ~= 0 then
            return {
                chips = card.ability.extra.chips
            }
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