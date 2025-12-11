SMODS.Seal{
    key = 'gold_joker_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 3, y = 1 },
    loc_txt = {
        name = 'Gold Joker Seal', --name of card
        label = 'Gold Joker Seal',
        text = { --text of card
            'Earn {C:gold}$#1#{} the first time',
            'this Joker triggers',
            'each round'
        }
    },
    config = { 
        extra = { 
            money = 3,
            round_counter = 0 
        } 
    },
    badge_colour = G.C.GOLD,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.seal.extra.round_counter = 0
        end
        if context.post_trigger and context.other_card == card and card.ability.seal.extra.round_counter == 0 then
            card.ability.seal.extra.round_counter = 1
            return {
                card = card,
                dollars = card.ability.seal.extra.money
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.money } }
    end,
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end
}