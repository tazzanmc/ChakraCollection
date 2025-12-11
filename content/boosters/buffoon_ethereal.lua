SMODS.Booster {
    key = "buffoon_ethereal",
    weight = 0.3,
    kind = 'Buffoon',   -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 1,
    atlas = 'Boosters', --atlas
    pos = { x = 0, y = 1 },
    loc_txt = {         -- local text
        name = 'Ethereal Buffoon Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_sticker_ethereal,E:2}Ethereal{} Joker cards'
        }
    },
    config = { extra = 6, choose = 1 },
    group_key = "k_buffoon_pack",
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            --key = self.key:sub(1, -3), -- This uses the description key of the booster without the number at the end
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
    create_card = function(self, card, i)
        ret = SMODS.create_card {
            set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf"
        }
        ret:add_sticker('chak_ethereal', true)
        return ret
    end,
}