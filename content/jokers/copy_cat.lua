local return_whitelist = {
    'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod', 'xmult_mod'
}

SMODS.Joker{ -- +Mult per other Joker triggered
    key = 'copy_cat', --joker key
    loc_txt = { -- local text
        name = 'Copy Cat',
        text = {
          '{C:mult}+#1#{} Mult per other {C:attention}Joker{}',
          'ability scored'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 1},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = { 
        extra = {
            mult = 4 --configurable value
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card ~= card and context.other_card.ability.set == "Joker" and context.other_ret.jokers then
            for _, key in ipairs(return_whitelist) do
                if context.other_ret.jokers[key] then
                    return {
                        card = card,
                        mult_mod = card.ability.extra.mult,
                        message = '+' .. card.ability.extra.mult .. ' Mult',
                        colour = G.C.MULT
                    }
                end
            end
        end
    end
}