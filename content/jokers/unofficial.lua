SMODS.Joker{ -- Dupe card in hand if 1 card in hand
    key = 'unofficial', --joker key
    loc_txt = { -- local text
        name = 'UNOfficial',
        text = {
          "Add {C:attention}#1#{} permanent copies",
          "of the card in hand if",
          "{C:attention}first hand{} is played with",
          "exactly {C:attention}1{} card in hand"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 7, y = 4},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pixel_size = { w = 62 },
    config = {
        extra = {
            copies = 2,
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.copies } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.before and G.GAME.current_round.hands_played == 0 and #G.hand.cards == 1 then
            for i = 1, card.ability.extra.copies do
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local copy_card = copy_card(G.hand.cards[i], nil, nil, G.playing_card)
                copy_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, copy_card)
                G.hand:emplace(copy_card)
                copy_card.states.visible = nil
                G.E_MANAGER:add_event(Event({
                    func = function()
                        copy_card:start_materialize()
                        return true
                    end
                }))
            end
            return {
                message = localize('k_copied_ex'),
                colour = G.C.MULT,
                func = function() -- This is for timing purposes, it runs after the message
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
                            return true
                        end
                    }))
                end
            }
        end
    end
}