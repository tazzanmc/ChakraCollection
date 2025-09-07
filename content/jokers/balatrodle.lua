SMODS.Joker { -- Gain mult if 5+ unique ranks in scoring hand
    key = "balatrodle",
    loc_txt = {
        name = "Balatrodle",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult if five",
            "or more {C:attention}unique ranks{}",
            "are in scoring hand",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 1},
    config = { 
        extra = { 
            Xmult = 1,
            Xmult_gain = 0.2,
            ranks = {}
        } 
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.ranks = {}
            for _, playing_card in ipairs(context.scoring_hand) do
                if not playing_card.debuff then
                    if not card.ability.extra.ranks[playing_card:get_id()] then
                        card.ability.extra.ranks[playing_card:get_id()] = true
                        sendDebugMessage("ranks:" .. playing_card:get_id(), "CHAK")
                    end
                end
            end
            if CHAK_UTIL.table_length(card.ability.extra.ranks) >= 5 then
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