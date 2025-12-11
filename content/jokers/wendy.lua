SMODS.Joker { -- Gain chips & mult for each discard card which is drawn as the same suit. Reset after beating boss
    key = "wendy",
    loc_txt = {
        name = "Wendy",
        text = {
            "Gains {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult for",
            "each discarded card which",
            "is drawn as the same suit",
            "{C:inactive}(Currently {C:chips}+#3# {C:inactive}Chips {C:mult}+#4# {C:inactive}Mult)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 6},
    config = {
        extra = {
            chip_gain = 6,
            mult_gain = 2,
            chips = 0,
            mult = 0,
            og_suits = {},
            new_suits = {},
            all_suits = {},
            cards_discarded = 0,
            discarded = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.discarded = 1
            card.ability.extra.og_suits = {}
            card.ability.extra.all_suits = {}
            card.ability.extra.cards_discarded = #G.hand.highlighted
            sendDebugMessage("cards_discarded" .. card.ability.extra.cards_discarded, "CHAK")
            og_suits = card.ability.extra.og_suits
            all_suits = card.ability.extra.all_suits
            for _, playing_card in ipairs(G.hand.cards) do -- Log og_suits in hand
                if not playing_card.debuff then
                    if not SMODS.has_any_suit(playing_card) then
                        logged_suit = playing_card.base.suit
                        if not og_suits[logged_suit] then
                            og_suits[logged_suit] = 1
                            all_suits[logged_suit] = 1
                        else
                            og_suits[logged_suit] = og_suits[logged_suit] + 1
                        end
                    end
                    if SMODS.has_any_suit(playing_card) then
                        local wild = "wild"
                        if not og_suits[wild] then
                            og_suits[wild] = 1
                            all_suits[wild] = 1
                        else
                            og_suits[wild] = og_suits[wild] + 1
                        end
                    end
                end
            end
        end
        if context.hand_drawn and card.ability.extra.discarded == 1 and not context.blueprint then
            card.ability.extra.discarded = 0
            card.ability.extra.new_suits = {}
            og_suits = card.ability.extra.og_suits
            new_suits = card.ability.extra.new_suits
            all_suits = card.ability.extra.all_suits
            for _, playing_card in ipairs(G.hand.cards) do -- Log new_suits in hand
                if not playing_card.debuff then
                    if not SMODS.has_any_suit(playing_card) then
                        logged_suit = playing_card.base.suit
                        if not new_suits[logged_suit] then
                            new_suits[logged_suit] = 1
                            all_suits[logged_suit] = 1
                        else
                            new_suits[logged_suit] = new_suits[logged_suit] + 1
                        end
                    end
                    if SMODS.has_any_suit(playing_card) then
                        local wild = "wild"
                        if not og_suits[wild] then
                            new_suits[wild] = 1
                            all_suits[wild] = 1
                        else
                            og_suits[wild] = og_suits[wild] + 1
                        end
                    end
                end
            end
            local difference = 0
            sendDebugMessage("Difference:" .. difference, "CHAK")
            sendDebugMessage("OG Suits:", "CHAK")
            print(og_suits)
            sendDebugMessage("New Suits:", "CHAK")
            print(new_suits)
            for suit_key, _ in pairs(all_suits) do -- Compare dictionaries
                local og_value = og_suits[suit_key] or 0
                local new_value = new_suits[suit_key] or 0
                difference = math.abs(og_value - new_value) + difference
                sendDebugMessage("Difference:" .. difference, "CHAK")
            end
            if card.ability.extra.cards_discarded > difference then
                for i = 1, card.ability.extra.cards_discarded - difference do
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                end
                return {
                    colour = G.C.PURPLE,
                    message = "Upgraded!"
                }
            end
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