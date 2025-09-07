SMODS.Joker{ -- Spawn common, uncommon, rare, negative, ethereal jokers
    key = 'black_lotus', --joker key
    loc_txt = { -- local text
        name = 'Black Lotus',
        text = {
            "{C:attention}+#1#{} hand size",
            "{C:red}Destroyed{} at end of round"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 9, y = 2},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 3, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            hand_size = 3
        }
    },
    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.extra.hand_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            G.GAME.pool_flags.chak_black_lotus_sacd = true
            sendDebugMessage("mox lotus in pool: true", "CHAK")
            SMODS.destroy_cards(card)
            return {
                message = 'Sac!',
                colour = G.C.CHAK_ETHEREAL
            }
        end
    end,
    in_pool = function(self, args) -- Don't appear if black lotus was sac'd
        return not G.GAME.pool_flags.chak_black_lotus_sacd
    end
}