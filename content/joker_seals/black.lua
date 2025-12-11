SMODS.Seal{
    key = 'black_joker_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 3, y = 0 },
    loc_txt = {
        name = 'Black Joker Seal', --name of card
        label = 'Black Joker Seal',
        text = { --text of card
            "Gains {X:mult,C:white}X#1#{} Mult when",
            "{C:attention}selling{} or {C:attention}destroying{} a",
            "Joker with a {C:attention}Joker Seal",
            '{C:inactive}(Currently{} {X:mult,C:white}X#2#{}{C:inactive})'
        }
    },
    config = { extra = { Xmult_gain = 0.25, Xmult = 1 } },
    badge_colour = G.C.BLACK,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.cardarea == G.jokers and context.card:get_seal() ~= nil then
            card.ability.seal.extra.Xmult = card.ability.seal.extra.Xmult + card.ability.seal.extra.Xmult_gain
            return {
                message = 'Upgraded!',
                colour = G.C.BLACK
            }
        end
        if context.selling_card and context.cardarea == G.jokers and context.card:get_seal() ~= nil then
            card.ability.seal.extra.Xmult = card.ability.seal.extra.Xmult + card.ability.seal.extra.Xmult_gain
            return {
                message = 'Upgraded!',
                colour = G.C.BLACK
            }
        end
        if context.post_joker and card.ability.seal.extra.Xmult ~= 1 then
            return { 
                xmult = card.ability.seal.extra.Xmult,
                colour = G.C.BLACK
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.Xmult_gain, card.ability.seal.extra.Xmult} }
    end
}