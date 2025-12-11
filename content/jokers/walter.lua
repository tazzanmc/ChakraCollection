SMODS.Joker { -- Gain chips for each diff discarded suit. Reset after beating boss
    key = "walter",
    loc_txt = {
        name = "Walter",
        text = {
            "Gains {C:chips}+#1#{} Chips for each",
            "{C:attention}different{} discarded suit",
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
    pos = {x = 7, y = 7},
    config = {
        extra = {
            chip_gain = 16,
            chips = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            local suits = {}
            local triggers = 0
            for _, playing_card in ipairs(G.hand.highlighted) do -- Log og_suits in hand
                if not playing_card.debuff then
                    if not SMODS.has_any_suit(playing_card) then
                        logged_suit = playing_card.base.suit
                        if not suits[logged_suit] then
                            suits[logged_suit] = 1
                        end
                    end
                    if SMODS.has_any_suit(playing_card) then
                        if not og_suits[wild] then
                            og_suits[wild] = 1
                        else
                            og_suits[wild] = og_suits[wild] + 1
                        end
                    end
                end
            end
            for suit_key, val in pairs(suits) do
                triggers = triggers + val
            end
            if triggers > 0 then
                card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chip_gain * triggers)
                return {
                    colour = G.C.CHIPS,
                    message = "+" .. (card.ability.extra.chip_gain * triggers)
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