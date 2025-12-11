SMODS.Consumable { -- Awaken rand Joker, destroy all others, +1 Ante
    key = 'sanctify',
    loc_txt = {
        name = 'Sanctify', --name of card
        text = { --text of card
            '{C:chak_sticker_awakened,E:1}Awaken{} a random Joker',
            "{C:attention}Destroy{} all other Jokers",
            "{C:attention}+#1#{} Ante"
        }
    },
    set = "Spectral",
    atlas = 'MiscConsumables',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            increase = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_awakened', set = 'Other'}
        return { vars = { card.ability.extra.increase } }
    end,
    can_use = function(self, card)
        local unawakened_available = false
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.chak_awakened then
                unawakened_available = true
            end
        end
        return G.jokers and #G.jokers.cards > 0 and unawakened_available
    end,
    use = function(self, card, area, copier)
        local unawakened_jokers = {}
        for i = 1, #G.jokers.cards do -- Unawakened jokers into a table
            if not G.jokers.cards[i].ability.chak_awakened then
                unawakened_jokers[#unawakened_jokers + 1] = G.jokers.cards[i]
            end
        end
        local chosen_joker = pseudorandom_element(unawakened_jokers, 'sanctify_choice') -- Pick rand joker
        local deletable_jokers = {}
        for i = 1, #G.jokers.cards do -- Unchosen jokers into a table
            if G.jokers.cards[i] ~= chosen_joker then
                deletable_jokers[#deletable_jokers + 1] = G.jokers.cards[i]
            end
        end
        CHAK_UTIL.use_consumable_animation(card, chosen_joker, function() -- Destroy 
                chosen_joker:add_sticker('chak_awakened', true)
                if #deletable_jokers ~= 0 then
                    SMODS.destroy_cards(deletable_jokers)
                end
                ease_ante(card.ability.extra.increase)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + card.ability.extra.increase
                return true
            end
        )
    end
}