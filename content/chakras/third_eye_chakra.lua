SMODS.Consumable{ -- Create negative, ethereal copy of Joker
    key = 'third_eye_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    atlas = 'Chakras', --atlas
    pos = {x = 1, y = 1}, --position in atlas
    loc_txt = {
        name = 'Third Eye', --name of card
        text = { --text of card
            'Create a {C:dark_edition}Negative{},',
            '{C:chak_sticker_ethereal,E:2}Ethereal{} copy of',
            '{C:attention}#1#{} selected Joker'
        }
    },
    config = {
        extra = {
            jokersselected = 1 --configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
        return {vars = {center.ability.extra.jokersselected}}
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
            if G.jokers.highlighted[i].edition and G.jokers.highlighted[i].edition.negative then
                    CHAK_UTIL.use_consumable_animation(card, nil, function()
                        --for every card in jokers highlighted
                        local copied_joker = copy_card(G.jokers.highlighted[i])
                        copied_joker:start_materialize()
                        copied_joker:add_to_deck()
                        copied_joker:add_sticker('chak_ethereal', true)
                        G.jokers:emplace(copied_joker)
                        return true
                    end
                )
            else
                CHAK_UTIL.use_consumable_animation(card, nil, function()
                        --for every card in jokers highlighted
                        local copied_joker = copy_card(G.jokers.highlighted[i])
                        copied_joker:start_materialize()
                        copied_joker:add_to_deck()
                        copied_joker:set_edition({negative = true})
                        copied_joker:add_sticker('chak_ethereal', true)
                        G.jokers:emplace(copied_joker)
                        return true
                    end
                )
            end
        end
    end,
} 