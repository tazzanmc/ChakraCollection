SMODS.Joker { -- Destroy random unscored card if hand played with 5 cards
    key = "a_clown_with_a_gun",
    loc_txt = {
        name = "A Clown With A Gun",
        text = {
            "When {C:attention}5{} cards are played,",
            "{C:attention}destroy{} a random unscored card"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    atlas = 'Jokers', --atlas' key
    pos = {x = 6, y = 5},
    calculate = function(self, card, context)
        if context.before and #context.full_hand == 5 then
            local scoring_cards = {}
            for i = 1, #context.scoring_hand do
                scoring_cards[#scoring_cards + 1] = context.scoring_hand[i]
            end
            local targets = {}
            for i = 1, #context.full_hand do
                if not CHAK_UTIL.table_contains(scoring_cards, context.full_hand[i]) then
                    targets[#targets + 1] = context.full_hand[i]
                end
            end
            if #targets ~= 0 then
                SMODS.destroy_cards(pseudorandom_element(targets, pseudoseed('chak_acwag')))
                return {
                    remove = true,
                    message = "Bang!",
                    colour = G.C.FILTER
                }
            end
        end
    end
}