SMODS.Seal{
    key = 'green_seal',
    sets = { Joker = true },
    atlas = 'JokerSeals',
    pos = { x = 2, y = 0 },
    loc_txt = {
        name = 'Green Joker Seal', --name of card
        label = 'Green Joker Seal',
        text = { --text of card
            '{X:mult,C:white}X#1#{} Mult for each',
            '{C:attention}Joker Seal',
            '{C:inactive}(Currently{} {X:mult,C:white}X#2#{}{C:inactive})'
        }
    },
    config = { extra = { Xmult_mod = 0.15, Xmult_base = 1 } },
    badge_colour = G.C.GREEN,
    calculate = function(self, card, context)
        if context.post_joker then
            local sealed_jokers = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i]:get_seal() ~= nil then
                    sealed_jokers = sealed_jokers + 1
                end
            end
            return { 
                xmult = (card.ability.seal.extra.Xmult_mod * sealed_jokers) + card.ability.seal.extra.Xmult_base,
                colour = G.C.GREEN
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        local sealed_jokers = 0
        local Xmult_current = 0
        if G.jokers ~= nil then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i]:get_seal() ~= nil then
                    sealed_jokers = sealed_jokers + 1
                end
            end
        else
            sealed_jokers = 1
        end
        Xmult_current = (card.ability.seal.extra.Xmult_mod * sealed_jokers) + card.ability.seal.extra.Xmult_base
        return { vars = { self.config.extra.Xmult_mod, Xmult_current } }
    end
}