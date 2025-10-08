SMODS.Sticker{
    key = 'fragile',
    atlas = 'Stickers',
    pos = { x = 3, y = 0 },
    loc_txt = {
        name = 'Fragile', --name of card
        label = 'Fragile',
        text = { --text of card
            '{C:attention}Shatters{}',
            'after scoring'
        }
    },
    discovered = true,
    badge_colour = G.C.CHAK_STICKER_FRAGILE,
    rate = 0,
    draw = function(self, card)
        -- Don't draw the shine over the sticker
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        if card.ability.eternal then 
            card:remove_sticker('eternal') 
        end
        if card.ability.perishable then 
            card:remove_sticker('perishable') 
        end
        if card.ability.chak_ethereal then
            card:remove_sticker('chak_ethereal')
        end
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card then -- Playing cards
            return { remove = true }
        end
        if context.after and context.cardarea == G.jokers and not context.repetition and not context.individual then -- Jokers
            SMODS.destroy_cards(card)
            return { remove = true }
        end
    end
}