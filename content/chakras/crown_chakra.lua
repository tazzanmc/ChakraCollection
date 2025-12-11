SMODS.Consumable{ -- Add random Joker Seal
    key = 'crown_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    soulable = true,
    atlas = 'Chakras', --atlas
    pos = {x = 2, y = 1}, --position in atlas
    loc_txt = {
        name = 'Crown', --name of card
        text = { --text of card
            'Add a random',
            '{C:attention}Joker Seal{} to',
            '{C:attention}#1#{} selected Joker'
        }
    },
    config = {
        extra = {
            jokersselected = 1,
            seals = {
                white_seal = 'chak_white_joker_seal',
                red_seal = 'chak_red_joker_seal',
                green_seal = 'chak_green_joker_seal',
                black_seal = 'chak_black_joker_seal',
                blue_seal = 'chak_blue_joker_seal',
                purple_seal = 'chak_purple_joker_seal',
                orange_seal = 'chak_orange_joker_seal',
                gold_seal = 'chak_gold_joker_seal'
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        --[[
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.white_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.red_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.green_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.black_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.blue_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.purple_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.orange_joker_seal]
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra.seals.gold_joker_seal]
        ]]
        return {vars = {card.ability.extra.jokersselected}}
    end,
    can_use = function(self,card)
            if G and G.jokers then
                if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then
                    return true
                end
            end
        return false
    end,
    use = function(self,card,area,copier)
        local seal_choice = math.random(8)
        for i = 1, #G.jokers.highlighted do
            CHAK_UTIL.use_consumable_animation(card, nil, function()
                    G.jokers.highlighted[i]:set_seal(pseudorandom_element(card.ability.extra.seals, 'crown_chakra'), nil, true)
                    play_sound('gold_seal', 1.2, 0.4)
                    return true
                end
            )
        end
    end
}