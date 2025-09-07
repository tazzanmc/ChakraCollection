SMODS.Joker{ -- Spawn common, uncommon, rare, negative, ethereal jokers
    key = 'mox_lotus', --joker key
    loc_txt = { -- local text
        name = 'Mox Lotus',
        text = {
            "{C:dark_edition}+#1#{} Joker slots",
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 2},
    soul_pos = {x = 8, y = 3},
    rarity = 4, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 20, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            card_limit = 3
        }
    },
    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.extra.card_limit } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.card_limit
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.card_limit
    end,
    in_pool = function(self, args) -- Only appear if black lotus was sac'd
        return G.GAME.pool_flags.chak_black_lotus_sacd
    end
}