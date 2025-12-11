SMODS.Joker { -- gain 1 mult for each heart kept. Resets after beating boss
    key = "wortox",
    loc_txt = {
        name = "Wortox",
        text = {
            "Gains {C:chips}+#1#{} Chips for each discarded {C:hearts}Heart{}",
            "Loses {C:chips}-#2#{} Chips and gains {C:mult}+#3#{} mult",
            "for each {C:hearts}Heart{} held in hand",
            "{C:inactive}(Currently {C:chips}+#4# {C:inactive}Chips {C:mult}+#5# {C:inactive}Mult)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'Jokers', --atlas' key
    pos = {x = 4, y = 7},
    config = {
        extra = {
            chip_gain = 15,
            chip_loss = 11,
            mult_gain = 1,
            chips = 0,
            mult = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chip_loss, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and context.other_card:is_suit("Hearts") then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                colour = G.C.CHIPS,
                message = "+" .. card.ability.extra.chip_gain
            }
        end
        if context.individual and context.cardarea == G.hand and context.other_card:is_suit("Hearts") and not context.blueprint and not context.end_of_round then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_loss
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                card = card,
                colour = G.C.PURPLE,
                message = "Modified!"
            }
        end
        if context.joker_main and ((card.ability.extra.mult ~= 0) or (card.ability.extra.chips ~= 0)) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
        if context.cardarea == G.jokers and context.end_of_round and G.GAME.blind:get_type() == "Boss" and not context.blueprint then
            card.ability.extra.chips = 0
            card.ability.extra.mult = 0
            return {
                colour = G.C.FILTER,
                message = "Reset!"
            }
        end
    end
}