SMODS.Joker{ -- xMult per destroyed Joker
    key = 'last_laugh', --joker key
    loc_txt = { -- local text
        name = 'Last Laugh',
        text = {
          'Gains {X:mult,C:white}X#1#{} Mult per Joker',
          '{C:attention}destroyed{} this run',
          '{C:inactive}(Currently{} {X:mult,C:white}X#2#{} {C:inactive}Mult){}'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = { 
        extra = {
          Xmult_gain = 1,
          Xmult = 1 --configurable value
        }
      },
      loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self, args) -- Don't appear while this joker's broken
        return false
    end
}