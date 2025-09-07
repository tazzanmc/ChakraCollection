SMODS.Seal{
    key = 'ethereal_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 0, y = 2 },
    loc_txt = {
        name = 'Ethereal Joker Seal', --name of card
        label = 'Ethereal Joker Seal',
        text = { --text of card
            '{C:dark_edition}+#1#{} Joker slot'
        }
    },
    config = { extra = { card_limit = 1 } },
    badge_colour = G.C.CHAK_STICKER_ETHEREAL,
    apply = function(self, card)
        if G.jokers ~= nil then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    end,
    remove = function(self, card)
        if G.jokers ~= nil then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.card_limit } }
    end,
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('negative_shine', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end
}   

