SMODS.Consumable{ -- Chance to remove eternal/rental/perishable
    key = 'throat_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    atlas = 'Chakras', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Throat', --name of card
        text = { --text of card
            '{C:green}#1# in #2#{} chance to {C:attention{}remove',
            '{C:chak_eternal,E:2}Eternal{}, {C:chak_rental,E:2}Rental{}, and/or',
            '{C:chak_perishable,E:2}Perishable{} from {C:attention}#3#{} selected Joker'
        }
    },
    config = {
        extra = {
            odds = 2,
            jokersselected = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', vars = {G.GAME.perishable_rounds or 1, G.GAME.perishable_rounds or 1}}
        info_queue[#info_queue+1] = {key = 'rental', set = 'Other', vars = {G.GAME.rental_rate or 1}}
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'chak_throat_chakra')
        return {vars = {numerator, denominator, card.ability.extra.jokersselected}}
    end,
    can_use = function(self,card)
            if G and G.jokers then
                if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then
                    for i = 1, #G.jokers.highlighted do
                        other_card = G.jokers.highlighted[i]
                        if other_card.ability.eternal or other_card.ability.perishable or other_card.ability.rental then --if eternal, perishable, or rental
                            return true
                        end
                    end
                end
            end
        return false
    end,
    use = function(self,card,area,copier)
        if SMODS.pseudorandom_probability(card, 'chak_throat_chakra', 1, card.ability.extra.odds) then
            for i = 1, #G.jokers.highlighted do
                CHAK_UTIL.use_consumable_animation(card, G.jokers.highlighted[i], function()
                        if G.jokers.highlighted[i].ability.eternal then
                            G.jokers.highlighted[i]:remove_sticker('eternal')
                        end
                        if G.jokers.highlighted[i].ability.perishable then
                            G.jokers.highlighted[i]:remove_sticker('perishable')
                        end
                        if G.jokers.highlighted[i].ability.rental then
                            G.jokers.highlighted[i]:remove_sticker('rental')
                        end
                        return true
                    end
                )
            end
        else
            CHAK_UTIL.show_nope_text(card, G.C.CHAK_EDITION)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.jokers:unhighlight_all()
                    return true
                end
            }))
        end
        delay(0.5)
    end,  
}