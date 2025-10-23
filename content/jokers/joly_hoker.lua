SMODS.Joker{ -- Awaken Ethereal Jokers
    key = 'joly_hoker', --joker key
    loc_txt = { -- local text
        name = 'Joly Hoker',
        text = {
          '{C:chak_sticker_awakened,E:1}Awaken {C:chak_sticker_ethereal,E:2}Ethereal{} Jokers'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 5},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'chak_awakened', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.joly_hoker = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.joly_hoker = false
    end,
    calculate = function(self, card, context)
        if card.ability.chak_awakened then
            G.GAME.pool_flags.joly_hoker_can_spawn = false
            card.getting_sliced = true
            card:start_dissolve()
            new_card = SMODS.add_card({
                set = 'Joker',
                key = 'j_chak_trinity',
                edition = card.edition,
                stickers = { "eternal" }
            })
            new_card:add_sticker('chak_awakened', true)
        end
    end,
    in_pool = function(self, args) -- Don't appear if transformed
        return not G.GAME.pool_flags.joly_hoker_can_spawn
    end
}