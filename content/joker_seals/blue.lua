SMODS.Seal{
    key = 'blue_seal',sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 0, y = 1 },
    loc_txt = {
        name = 'Blue Joker Seal', --name of card
        label = 'Blue Joker Seal',
        text = { --text of card
            '{C:attention}+#1#{} {C:blue}Hand{} or {C:attention}+#1#{} {C:red}Discard{},',
            "whichever's lower"
        }
    },
    config = { extra = { amount = 1 } },
    badge_colour = G.C.BLUE,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 1,
                func = function()
                    local res = CHAK_UTIL.get_lowest_hand_discard()
                    local func = res.hands and ease_hands_played or ease_discard
                    local message = res.hands and 'a_hands' or 'chak_a_discards'

                    func(card.ability.seal.extra.amount, true)

                    SMODS.calculate_effect({
                        message = localize {
                            type = 'variable',
                            key = message .. (res.amt < 0 and '_minus' or ''),
                            vars = { card.ability.seal.extra.amount }
                        },
                        colour = res.hands and G.C.CHIPS or G.C.MULT,
                        instant = true
                    }, card)
                    return true
                end
            })
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.amount } }
    end
}