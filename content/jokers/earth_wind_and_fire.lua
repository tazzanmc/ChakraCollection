SMODS.Joker { -- Gain mult if 3+ unique suits in hand
    key = "earth_wind_and_fire",
    loc_txt = {
        name = "Earth, Wind & Fire",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult if three",
            "or more {C:attention}unique suits{}",
            "are held in hand",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'Jokers', --atlas' key
    pos = {x = 4, y = 2},
    config = { 
        extra = { 
            Xmult = 1,
            Xmult_gain = 0.15,
            suits = {}
        } 
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.suits = {}
            for _, playing_card in ipairs(G.hand.cards) do
                if not playing_card.debuff then
                    if not SMODS.has_any_suit(playing_card) then
                        if not card.ability.extra.suits[playing_card.base.suit] then
                            card.ability.extra.suits[playing_card.base.suit] = true
                            sendDebugMessage("suits:" .. playing_card.base.suit, "CHAK")
                        end
                    end
                    if SMODS.has_any_suit(playing_card) then
                        table.insert(card.ability.extra.suits, "Wild")
                        sendDebugMessage("suits: Wild", "CHAK")
                    end
                end
            end
            if CHAK_UTIL.table_length(card.ability.extra.suits) >= 3 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.Xmult ~= 1 then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}