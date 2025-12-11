SMODS.Consumable { -- Remove ethereal from rand Joker, destroy rand Joker
    key = 'realize',
    loc_txt = {
        name = 'Realize', --name of card
        text = { --text of card
            'Remove {C:chak_sticker_ethereal,E:2}Ethereal{} from',
            'a random Joker',
            "{C:attention}Destroy{} a random joker"
        }
    },
    set = "Spectral",
    atlas = 'MiscConsumables',
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
    end,
    can_use = function(self, card) -- line 17
        local has_ethereal = false
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.chak_ethereal then
                has_ethereal = true
            end
        end
        return G.jokers and #G.jokers.cards > 0 and has_ethereal
    end,
    use = function(self, card, area, copier)
        local ethereal_jokers = {}
        for i = 1, #G.jokers.cards do -- Ethereal jokers into a table
            if G.jokers.cards[i].ability.chak_ethereal then
                ethereal_jokers[#ethereal_jokers + 1] = G.jokers.cards[i]
            end
        end
        local chosen_joker = pseudorandom_element(ethereal_jokers, 'realize_choice') -- Pick rand ethereal
        local deletable_jokers = {}
        for i = 1, #G.jokers.cards do -- Unchosen jokers into a table
            if G.jokers.cards[i] ~= chosen_joker then
                deletable_jokers[#deletable_jokers + 1] = G.jokers.cards[i]
            end
        end
        if #deletable_jokers ~= 0 then
            local deletable_joker = pseudorandom_element(deletable_jokers, 'realize_choice') -- Pick rand unchosen
        end
        CHAK_UTIL.use_consumable_animation(card, chosen_joker, function() -- Destroy 
                chosen_joker:remove_sticker('chak_ethereal')
                if deletable_joker ~= nil then
                    SMODS.destroy_cards(deletable_joker)
                end
                return true
            end
        )
    end
}