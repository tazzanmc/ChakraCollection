CHAK_UTIL.TokenJoker{ -- +mult & +chip token
    key = 'joe_joker',
    loc_txt = {
        name = "Joe Joker",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:chips}+#2#{} Chips"
        }
    },
    atlas = 'Jokers',
    pos = {x = 6, y = 3 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            mult = 2,
            chips = 25,
            card_limit = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end
}