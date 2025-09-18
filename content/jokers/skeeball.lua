SMODS.Joker{ -- xMult own chips = # of scoring 10's
    key = 'skeeball', --joker key
    loc_txt = { -- local text
        name = 'Skeeball',
        text = {
          'Multiplies own {C:chips}Chips{} by {X:chips,C:white}X#1#.C{}.',
          '{X:chips,C:white}C{} is equal to the number',
          "of scoring {C:attention}10's{} this hand",
          '{C:inactive}(Currently{} {C:chips}+#2#{} {C:inactive}Chips)'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 7, y = 1},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            chip_gain = 1,
            chips = 10,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
	end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local ten_count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 10 then
                    ten_count = ten_count + 1
                end
            end
            if ten_count > 0 then
                card.ability.extra.chips = math.ceil(card.ability.extra.chips * (card.ability.extra.chip_gain + (ten_count / 10)))
                return {
                    message = 'Upgraded!',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.chips ~= 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}