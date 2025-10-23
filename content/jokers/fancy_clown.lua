SMODS.Joker { -- +1 hand size (up to 5) for each consec hand w/ 5 scoring cards
    key = "fancy_clown",
    loc_txt = {
        name = "Fancy Clown",
        text = {
            "Gain {C:attention}+#1#{} hand size per",
            "{C:attention}consequtive{} hand played",
            "with 5 scoring cards",
            "{C:inactive}(Currently {C:attention}+#2# {C:inactive}hand size)",
            "{C:inactive,s:0.8}(Maximum of +#3# hand size)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 5},
    config = { 
        extra = { 
            h_size_gain = 1,
            h_size = 0,
            max_h_size = 5
        } 
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size_gain, card.ability.extra.h_size, card.ability.extra.max_h_size } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local scoring_cards = 0
            for _, playing_card in ipairs(context.scoring_hand) do
                scoring_cards = scoring_cards + 1
            end 
            if scoring_cards >= 5 and card.ability.extra.h_size < card.ability.extra.max_h_size then
                G.hand:change_size(card.ability.extra.h_size_gain)
                card.ability.extra.h_size = card.ability.extra.h_size + card.ability.extra.h_size_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.FILTER,
                    card = card
                }
            elseif scoring_cards < 5 and card.ability.extra.h_size ~= 0 then
                G.hand:change_size(-card.ability.extra.h_size)
                card.ability.extra.h_size = 0
                return {
                    message = 'Reset!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end
}