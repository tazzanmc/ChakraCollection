SMODS.Joker{ -- Lucky cards always score +20 mult, never $20
    key = 'certainty', --joker key
    loc_txt = { -- local text
        name = 'Certainty',
        text = {
            "{C:attention}Lucky{} cards always give",
            "{C:mult}+20{} Mult, and never {C:money}$20"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.chak_certainty = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        local has_certainty = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == "chak_certainty" then
                has_certainty = has_certainty + 1
            end
        end
        if has_certainty <= 1 then
            G.GAME.modifiers.chak_certainty = false
        end
    end
}