SMODS.Joker{ -- Seal adjacent Jokers when sold
    key = 'wishbone', --joker key
    loc_txt = { -- local text
        name = 'Wishbone',
        text = {
          '{C:attention}Sell{} this Joker to',
          'add a random {C:attention}Joker Seal{}',
          "to {C:attention}adjacent{} Jokers"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 6, y = 2},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            seals = {
                white_seal = 'chak_white_joker_seal',
                red_seal = 'chak_red_joker_seal',
                green_seal = 'chak_green_joker_seal',
                black_seal = 'chak_black_joker_seal',
                blue_seal = 'chak_blu_jokere_seal',
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
    end,
    calculate = function(self,card,context)
        if context.selling_self and card.area == G.jokers and not context.blueprint then
            local left_joker = nil
            local right_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    if G.jokers.cards[i - 1] ~= nil then -- Ensure left Joker exists
                        left_joker = G.jokers.cards[i - 1] 
                    end
                    if G.jokers.cards[i + 1] ~= nil then -- Ensure right Joker exists
                        right_joker = G.jokers.cards[i + 1] 
                    end
                end
            end
            if left_joker ~= nil then -- Apply left sticker
                left_joker:set_seal(pseudorandom_element(card.ability.extra.seals, 'chak_wishbone'), nil, true)
                play_sound('gold_seal', 1.2, 0.4)
                left_joker:juice_up()
            end
            if right_joker ~= nil then -- Apply right sticker
                right_joker:set_seal(pseudorandom_element(card.ability.extra.seals, 'chak_wishbone'), nil, true)
                play_sound('gold_seal', 1.2, 0.4)
                right_joker:juice_up()
            end
            play_sound('gold_seal', 1.2, 0.4)
            return {
                message = "Granted!",
                colour = G.C.FILTER
            }
        end
    end
}