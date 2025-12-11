local return_whitelist = {
    'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod', 'xmult_mod'
}

SMODS.Seal{
    key = 'red_joker_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Red Joker Seal', --name of card
        label = 'Red Joker Seal',
        text = { --text of card
            "Retrigger this Joker's",
            '{C:attention}scoring ability'
        }
    },
    config = { extra = { retriggers = 1 } },
    badge_colour = G.C.RED,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and context.other_card == card and context.other_ret.jokers then
            for _, key in ipairs(return_whitelist) do
                if context.other_ret.jokers[key] then
                    return {
                        repetitions = card.ability.seal.extra.retriggers,
                        colour = G.C.RED
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.retriggers } }
    end
}