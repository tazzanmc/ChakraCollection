SMODS.Joker { -- Gain mult if played hand has a Heart, Diamond, Spade & Club. Reset after beating boss
    key = "warly",
    loc_txt = {
        name = "Warly",
        text = {
            "Gains {C:mult}+#1#{} Mult if played hand",
            "contains a {C:hearts}Heart{}, {C:clubs}Club{},", 
            "{C:diamonds}Diamond{}, and {C:spades}Spade{}",
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
    pos = {x = 2, y = 7},
    config = {
        extra = {
            mult_gain = 4,
            mult = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local suits = {
                ['Hearts'] = 0,
                ['Diamonds'] = 0,
                ['Spades'] = 0,
                ['Clubs'] = 0
            }
            for i = 1, #context.full_hand do
                if not SMODS.has_any_suit(context.full_hand[i]) then
                    if context.full_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then
                        suits["Hearts"] = suits["Hearts"] + 1
                    elseif context.full_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0 then
                        suits["Diamonds"] = suits["Diamonds"] + 1
                    elseif context.full_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0 then
                        suits["Spades"] = suits["Spades"] + 1
                    elseif context.full_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0 then
                        suits["Clubs"] = suits["Clubs"] + 1
                    end
                end
            end
            for i = 1, #context.full_hand do
                if SMODS.has_any_suit(context.full_hand[i]) then
                    if context.full_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then
                        suits["Hearts"] = suits["Hearts"] + 1
                    elseif context.full_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0 then
                        suits["Diamonds"] = suits["Diamonds"] + 1
                    elseif context.full_hand[i]:is_suit('Spades') and suits["Spades"] == 0 then
                        suits["Spades"] = suits["Spades"] + 1
                    elseif context.full_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0 then
                        suits["Clubs"] = suits["Clubs"] + 1
                    end
                end
            end
            if suits["Hearts"] > 0 and
                suits["Diamonds"] > 0 and
                suits["Spades"] > 0 and
                suits["Clubs"] > 0 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    colour = G.C.RED,
                    message = "Upgraded!"
                }
            end
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