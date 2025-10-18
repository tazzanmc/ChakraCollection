SMODS.Joker{ -- Diamonds in hand either +$ or xMult
    key = 'derk', --joker key
    loc_txt = { -- local text
        name = 'Derk',
        text = {
          '{C:green}#1# in #2#{} chance to give',
          '{X:mult,C:white}X#3#{} Mult, otherwise',
          "give {X:mult,C:white}X#4#{} Mult"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 2, y = 3},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 3, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            odds = 2,
            Xmult_good = 3,
            Xmult_bad = 0.5
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'chak_derk')
        return {vars = {numerator, denominator, card.ability.extra.Xmult_good, card.ability.extra.Xmult_bad}}
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, 'chak_derk'..card.sort_id, 1, card.ability.extra.odds) then
                if card.ability.extra.Xmult_good ~= 1 then 
                    return {
                        Xmult_mod = card.ability.extra.Xmult_good,
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult_good } }
                    }
                end
            else
                if card.ability.extra.Xmult_bad ~= 1 then 
                    return {
                        Xmult_mod = card.ability.extra.Xmult_bad,
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult_bad } }
                    }
                end
            end
        end
    end
}