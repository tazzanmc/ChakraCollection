SMODS.Joker{ -- Copy rightmost Joker when Spades in hand
    key = 'water', --joker key
    loc_txt = { -- local text
        name = 'Water',
        text = {
          'Copy the rightmost {C:attention}Joker',
          'when a {C:spades}Spade{} is held in hand'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 2},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local other_joker = G.jokers.cards[#G.jokers.cards]
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
            local other_joker = G.jokers.cards[#G.jokers.cards]
            for i,v in ipairs(G.hand.cards) do
                local eval = function(other_card) return other_card:is_suit("Spades") end
                juice_card_until(card, eval, true)
                if v:is_suit("Spades") then
                    local ret = SMODS.blueprint_effect(card, other_joker, context)
                    if ret then
                        ret.colour = G.C.SUITS.Spades
                    end
                    return ret
                end
            end
        end
    end
}