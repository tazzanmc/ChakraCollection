SMODS.Joker{ -- +1 hand size for Clubs in hand
    key = 'wind', --joker key
    loc_txt = { -- local text
        name = 'Wind',
        text = {
          '{C:attention}+#1#{} hand size for',
          'each {C:clubs}Club{} held in hand'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 2},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            handsize = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.handsize } }
	end,
    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.hand and not context.end_of_round then
                if context.other_card:is_suit("Clubs") then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED,
                            card = card,
                        }
                    else
                        G.hand:change_size(card.ability.extra.handsize)
                        return {
                            message = localize { type = 'variable', key = 'a_handsize', vars = { card.ability.extra.handsize } },
                            card = card
                        }
                    end
                end
            end
        end
        if context.end_of_round and not context.blueprint then 
            if context.individual then
                if context.other_card:is_suit("Clubs") then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED,
                            card = card,
                        }
                    else
                        G.hand:change_size(-card.ability.extra.handsize)
                        return {
                            message = localize { type = 'variable', key = 'a_handsize_minus', vars = { card.ability.extra.handsize } },
                            card = card
                        }
                    end
                end
            end
        end
    end
}