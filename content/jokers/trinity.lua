SMODS.Joker{ -- three of a kind+ = awaken random
    key = 'trinity', --joker key
    loc_txt = { -- local text
        name = 'Trinity',
        text = {
            "When a hand containing {C:attention}Three",
            "{C:attention}of a Kind{} is scored,",
            "{C:chak_sticker_awakened}Awaken{} a random Joker"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 5},
    soul_pos = {x = 2, y = 5},
    rarity = 4, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 20, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, card)
        if not card.ability.chak_awakened then
            info_queue[#info_queue+1] = {key = 'chak_awakened', set = 'Other'}
        end
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Three of a Kind']) and not context.blueprint then
            local non_awakened_jokers = {}
            for i = 1, #G.jokers.cards do -- Non-awakened jokers into a table
                if not G.jokers.cards[i].ability.chak_awakened then
                    non_awakened_jokers[#non_awakened_jokers + 1] = G.jokers.cards[i]
                end
            end
            if #non_awakened_jokers ~= 0 then
                local chosen_joker = pseudorandom_element(non_awakened_jokers, 'chak_trinity'..card.sort_id) -- Pick rand non-awakened
                CHAK_UTIL.use_consumable_animation(card, chosen_joker, function()
                        chosen_joker:add_sticker('chak_awakened', true)
                        play_sound('gold_seal', 1.2, 0.4)
                        return true
                    end
                )
                return {
                    message = 'Awaken, my love!',
                    colour = G.C.CHAK_STICKER_AWAKENED
                }
            end
        end
    end,
    in_pool = function(self, args) -- Don't appear
        return false
    end
}