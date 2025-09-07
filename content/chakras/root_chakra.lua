SMODS.Consumable{ -- Eternal selected Joker
    key = 'root_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    atlas = 'Chakras', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = {
        name = 'Root', --name of card
        text = { --text of card
            'Add {C:chak_eternal,E:2}Eternal{} to',
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
                    for i = 1, #G.jokers.highlighted do
                        other_card = G.jokers.highlighted[i]
                        if other_card.ability.eternal == nil and other_card.config.center.eternal_compat and not other_card.ability.perishable and not other_card.ability.chak_ethereal then --if not eternal, can be eternal, and isn't perishable
                            return true
                        end
                    end
                end
            end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.jokers.highlighted do 
            CHAK_UTIL.use_consumable_animation(card, nil, function()
                    --for every card in jokers highlighted
                    G.jokers.highlighted[i]:set_eternal(true)
                    --set to eternal
                    G.jokers.highlighted[i]:juice_up(0.3, 0.3)
                    play_sound('gold_seal', 1.2, 0.4)
                    return true
                end
            )
        end
    end,  
}