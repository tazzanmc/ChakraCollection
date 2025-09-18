CHAK_UTIL.TokenJoker{ -- Spawn Joe Jokers, give mult for each Joker
    key = 'geep', --joker key
    loc_txt = { -- local text
        name = 'Geep',
        text = {
          "Gives {C:white,X:mult}X#1#{} Mult for",
          "each {C:chak_token}Token{} Joker card",
          "{C:attention}Splits{} when sold",
          "{C:inactive}(Currently {C:white,X:mult}X#2# {C:inactive} Mult)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 4},
    cost = 0,
    eternal_compat = false, --can it be eternal
    config = {
        extra = {
            increase = 1,
            joker_key = 'j_chak_gip',
            token_jokers = 0,
            Xmult_gain = 0.4
        },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
        if G.jokers ~= nil then
            card.ability.extra.token_jokers = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.rarity == "chak_Token" then
                    card.ability.extra.token_jokers = card.ability.extra.token_jokers + 1
                end
            end
        end
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult_gain * (card.ability.extra.token_jokers or 0) + 1 } }
    end,
    calculate = function(self,card,context)
        if context.selling_card and context.cardarea == G.jokers and context.card == card and not context.blueprint then
            for i = 1, 2 do
                SMODS.add_card {
                    area = G.jokers,
                    key = card.ability.extra.joker_key,
                    sell_cost = 0
                }
            end
            return {
                message = "Split!",
                colour = G.C.FILTER,
            }
        end
        if context.joker_main then
            card.ability.extra.token_jokers = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.rarity == "chak_Token" then
                    card.ability.extra.token_jokers = card.ability.extra.token_jokers + 1
                end
            end
            return {
                xmult = card.ability.extra.Xmult_gain * (card.ability.extra.token_jokers or 0) + 1
            }
        end
    end
}