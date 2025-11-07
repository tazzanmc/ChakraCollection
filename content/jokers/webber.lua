SMODS.Joker { -- Gain mult for each discarded light suit drawn for dark suit. Reset after beating boss
    key = "webber",
    loc_txt = {
        name = "Webber",
        text = {
            "Gains {C:mult}+#1#{} Mult for each {C:chak_light_suit}Light Suit",
            "discarded for a {C:chak_dark_suit}Dark Suit",
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
    pos = {x = 1, y = 7},
    config = {
        extra = {
            mult_gain = 2,
            mult = 0,
            og_suits = {
                light = 0,
                dark = 0
            },
            new_suits = {
                light = 0,
                dark = 0
            },
            discarded = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = CHAK_UTIL.suit_tooltip('light')
        info_queue[#info_queue + 1] = CHAK_UTIL.suit_tooltip('dark')
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.discarded = 1
            og_suits = card.ability.extra.og_suits
            og_suits.light = 0
            og_suits.dark = 0
            for _, playing_card in ipairs(G.hand.cards) do -- Log og_suits in hand
                if not playing_card.debuff then
                    if not SMODS.has_any_suit(playing_card) then
                        if CHAK_UTIL.is_suit(playing_card, 'light') then
                            og_suits.light = og_suits.light + 1
                        elseif CHAK_UTIL.is_suit(playing_card, 'dark') then
                            og_suits.dark = og_suits.dark + 1
                        end
                    end
                    if SMODS.has_any_suit(playing_card) then
                        og_suits.light = og_suits.light + 1
                        og_suits.dark = og_suits.dark + 1
                    end
                end
            end
        end
        if context.hand_drawn and card.ability.extra.discarded == 1 and not context.blueprint then
            card.ability.extra.discarded = 0
            og_suits = card.ability.extra.og_suits
            new_suits = card.ability.extra.new_suits
            new_suits.light = 0
            new_suits.dark = 0
            for _, playing_card in ipairs(G.hand.cards) do -- Log new_suits in hand
                if not playing_card.debuff then
                    if not SMODS.has_any_suit(playing_card) then
                        if CHAK_UTIL.is_suit(playing_card, 'light') then
                            new_suits.light = new_suits.light + 1
                        elseif CHAK_UTIL.is_suit(playing_card, 'dark') then
                            new_suits['dark'] = new_suits['dark'] + 1
                        end
                    end
                    if SMODS.has_any_suit(playing_card) then
                        new_suits.light = new_suits.light + 1
                        new_suits.dark = new_suits.dark + 1
                    end
                end
            end
            sendDebugMessage("OG Suits:", "CHAK")
            print(og_suits)
            sendDebugMessage("New Suits:", "CHAK")
            print(new_suits)
            local triggers = new_suits.dark - og_suits.dark
            if triggers > 0 then
                card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_gain * triggers)
                return {
                    colour = G.C.MULT,
                    message = "Upgraded!"
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