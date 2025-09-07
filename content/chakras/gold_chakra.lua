SMODS.Consumable{ -- Eternal selected Joker
    key = 'gold_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    hidden = true,
    atlas = 'Chakras', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = {
        name = 'Ethereal', --name of card
        text = { --text of card
            'Add {C:chak_eternal,E:2}ethereal seal{} to',
            '{C:attention}#1#{} selected Joker'
        }
    },
    config = {
        extra = {
            jokersselected = 1, --configurable value
        }
    },
    loc_vars = function(self,info_queue, center)
        info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
        return {vars = {center.ability.extra.jokersselected}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
            if G and G.jokers then
                if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then --if cards in jokers highlighted are above 0 but below the configurable value then
                    return true
                end
            end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.jokers.highlighted do 
            --for every card in jokers highlighted
            G.jokers.highlighted[i]:set_seal('chak_ethereal_seal', nil, true)
            --set to eternal
            G.jokers.highlighted[i]:juice_up(0.3, 0.3)
            play_sound('gold_seal', 1.2, 0.4)
            play_sound('negative', 1.5, 0.4)
        end
    end,  
}