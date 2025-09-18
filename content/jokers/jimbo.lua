SMODS.Joker{ -- Spawn Joe Jokers, give mult for each Joker
    key = 'jimbo', --joker key
    loc_txt = { -- local text
        name = 'Jimbo',
        text = {
          'When entering a blind, create',
          'an {C:chak_sticker_ethereal}Ethereal {C:chak_token}Token {C:attention}Joe Joker{} ',
          "for each Joker card. Gives {C:white,X:mult}X#1#{}",
          "Mult for each Joker card",
          "{C:inactive}(Currently {C:white,X:mult}X#2# {C:inactive} Mult)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 7, y = 2},
    soul_pos = {x = 7, y = 3},
    rarity = 4, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 20, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            Xmult_gain = 0.5,
            joker_key = 'j_chak_joe_joker'
        },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
        info_queue[#info_queue + 1] = G.P_CENTERS.j_chak_joe_joker
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult_gain * (G.jokers and #G.jokers.cards or 0) + 1 } }
    end,
    calculate = function(self,card,context)
        if context.setting_blind and context.cardarea == G.jokers and not context.blueprint then
            for i = 1, #G.jokers.cards do
                local created_joker = SMODS.add_card {
                    area = G.jokers,
                    key = card.ability.extra.joker_key
                }
                created_joker:add_sticker('chak_ethereal', true)
            end
            return {
                message = "Joke's on us!",
                colour = G.C.FILTER,
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult_gain * (G.jokers and #G.jokers.cards or 0) + 1
            }
        end
    end
}