SMODS.Consumable{ -- Foil selected Joker
    key = 'sacral_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    atlas = 'Chakras', --atlas
    pos = {x = 1, y = 0}, --position in atlas
    loc_txt = {
        name = 'Sacral', --name of card
        text = { --text of card
            'Add {C:dark_edition}Foil{} to',
            '{C:attention}#1#{} selected Joker'
        }
    },
    config = {
        extra = {
            jokersselected = 1, --configurable value
        }
    },
    loc_vars = function(self,info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        return {vars = {center.ability.extra.jokersselected}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        if G and G.jokers then
            if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected and #G.jokers.highlighted then --if cards in jokers highlighted are above 0 but below the configurable value and has no editions then
                for i = 1, #G.jokers.highlighted do
                    if G.jokers.highlighted[i]:get_edition() == nil then
                        return true
                    end
                end
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.jokers.highlighted do 
            CHAK_UTIL.use_consumable_animation(card, G.jokers.highlighted[i], function()
                    G.jokers.highlighted[i]:set_edition({foil = true},true)
                    return true
                end
            )
        end
    end,
}