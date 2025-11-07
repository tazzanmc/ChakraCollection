CHAK_UTIL.TokenJoker{ -- +mult & +chip token
    key = 'leftover_card',
    loc_txt = {
        name = "Leftover Card",
        text = {
            "Sell this Joker to",
            "immediately {C:attention}draw{} #1# card"
        }
    },
    atlas = 'Jokers',
    pos = { x = 8, y = 5 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = {
        extra = {
            increase = 1,
            draw = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
        return { vars = { card.ability.extra.draw } }
    end,
    calculate = function(self, card, context)
        if context.selling_self and card.area == G.jokers and next(G.hand.cards) then
            SMODS.draw_cards(card.ability.extra.draw)
        end
    end
}