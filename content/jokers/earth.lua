SMODS.Joker{ -- Diamonds in hand either +$ or xMult
    key = 'earth', --joker key
    loc_txt = { -- local text
        name = 'Earth',
        text = {
          '{C:green}#1# in #2#{} chance for',
          '{C:diamonds}Diamonds{} held in hand to',
          "give {C:money}$#3#{} and/or {X:mult,C:white}X#4#{} Mult"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 2},
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
            odds = 2,
            money = 1,
            Xmult = 1.5
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'chak_earth')
        return {vars = {numerator, denominator, card.ability.extra.money, card.ability.extra.Xmult}}
	end,
    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.hand and not context.end_of_round then
                if context.other_card:is_suit("Diamonds") then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED,
                            card = card,
                        }
                    else
                        if SMODS.pseudorandom_probability(card, 'chak_earth', 1, card.ability.extra.odds) and SMODS.pseudorandom_probability(card, 'chak_earth', 1, card.ability.extra.odds) then
                            return {
                                dollars = card.ability.extra.money,
                                Xmult_mod = card.ability.extra.Xmult,
                                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                                card = card
                            }
                        elseif SMODS.pseudorandom_probability(card, 'chak_earth', 1, card.ability.extra.odds) then
                            return {
                                dollars = card.ability.extra.money,
                                card = card
                            }
                        elseif SMODS.pseudorandom_probability(card, 'chak_earth', 1, card.ability.extra.odds) then
                            return {
                                Xmult_mod = card.ability.extra.Xmult,
                                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                                card = card
                            }
                        end
                    end
                end
            end
        end
    end
}