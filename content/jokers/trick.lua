CHAK_UTIL.TokenJoker{ -- +mult & +chip token
    key = 'trick',
    loc_txt = {
        name = "Trick",
        text = {
            "Sell this Joker for",
            '{C:attention}+#1#{} {C:blue}Hand{} or {C:attention}+#1#{} {C:red}Discard{},',
            "whichever's lower"
        }
    },
    atlas = 'Jokers',
    pos = { x = 9, y = 5 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = {
        extra = {
            increase = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
        return { vars = { card.ability.extra.increase, card.ability.extra.increase } }
    end,
    calculate = function(self, card, context)
        if context.selling_self and card.area == G.jokers then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local res = CHAK_UTIL.get_lowest_hand_discard()
                    local func = res.hands and ease_hands_played or ease_discard
                    local message = res.hands and 'a_hands' or 'chak_a_discards'

                    func(card.ability.extra.increase, true)

                    SMODS.calculate_effect({
                        message = localize {
                            type = 'variable',
                            key = message .. (res.amt < 0 and '_minus' or ''),
                            vars = { card.ability.extra.increase }
                        },
                        colour = res.hands and G.C.CHIPS or G.C.MULT,
                        instant = true
                    }, card)
                    return true
                end
            })
        end
    end
}