SMODS.Seal{
    key = 'white_joker_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'White Joker Seal', --name of card
        label = 'White Joker Seal',
        text = { --text of card
            '{C:attention}+#1#{} hand size'
        }
    },
    config = { extra = { hand_size = 1 } },
    badge_colour = G.C.JOKER_GREY,
    apply = function(self, card)
        if G.hand ~= nil then
            G.hand:change_size(card.ability.seal.extra.hand_size)
        end
    end,
    remove = function(self, card)
        if G.hand ~= nil then
            G.hand:change_size(-card.ability.seal.extra.hand_size)
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.hand_size } }
    end
}   

