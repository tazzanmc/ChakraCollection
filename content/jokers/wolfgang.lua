SMODS.Joker { -- Gain chips when King scored. Reset after beating boss
    key = "wolfgang",
    loc_txt = {
        name = "Wolfgang",
        text = {
            "Gains {C:chips}+#1#{} Chips when",
            "a {C:attention}King{} is scored",
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
    pos = {x = 2, y = 6},
    config = {
        extra = {
            chip_gain = 25,
            chips = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 13 and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                card = card,
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