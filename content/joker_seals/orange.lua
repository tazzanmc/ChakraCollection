SMODS.Seal{
    key = 'orange_joker_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 2, y = 1 },
    loc_txt = {
        name = 'Orange Joker Seal', --name of card
        label = 'Orange Joker Seal',
        text = { --text of card
            'This Joker cannot',
            'be {C:attention}debuffed{}'
        }
    },
    config = { extra = { retriggers = 1 } },
    badge_colour = G.C.ORANGE,
    apply = function(self, card)
        SMODS.debuff_card(card, "prevent_debuff", "orange_seal")
    end,
    in_pool = function(self, args)
        return false
    end,
    remove = function(self, card)
        SMODS.debuff_card(card, false, "orange_seal")
    end
}