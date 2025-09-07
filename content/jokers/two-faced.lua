SMODS.Joker{ -- Copy left. debuff right
    key = 'two-faced',
    loc_txt = {
        name = 'Two-Faced',
        text = {
            'Copies ability of Joker',
            'to the {C:attention}left{}. {C:red}Debuffs',
            'Joker to the {C:attention}right'
        }
    },
    atlas = 'Jokers',
    pos = {x = 4, y = 1},
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i - 1] end
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        local other_joker = nil
        local debuff_joker = nil
        for i = 1, #G.jokers.cards do -- Mark Joker to copy and debuff, choose debuffed Joker
            if G.jokers.cards[i] == card then 
                if G.jokers.cards[i - 1] ~= nil then -- Ensure copy Joker exists
                    other_joker = G.jokers.cards[i - 1] 
                end
                if G.jokers.cards[i + 1] ~= nil then -- Ensure debuff Joker exists
                    debuff_joker = G.jokers.cards[i + 1] 
                    debuff_joker.ability.two_faced_chosen = true
                end
            end
        end
        if debuff_joker ~= nil and not (debuff_joker.debuff and debuff_joker.debuffed_by_blind) then -- Debuff chosen Joker if not aready debuffed
            if debuff_joker.ability.two_faced_chosen and debuff_joker:get_seal() ~= "chak_orange_seal"  then
                SMODS.debuff_card(debuff_joker, true, "two-faced")
            end
        end
        for i = 1, #G.jokers.cards do -- Undebuff previously chosen Jokers which aren't currently chosen
            if G.jokers.cards[i].ability.two_faced_chosen and G.jokers.cards[i] ~= debuff_joker then
                if not G.jokers.cards[i].debuffed_by_blind then
                    G.jokers.cards[i].ability.two_faced_chosen = false
                    SMODS.debuff_card(G.jokers.cards[i], false, "two-faced")
                end
            end
        end
        local ret = SMODS.blueprint_effect(card, other_joker, context) -- Copy
        if ret then
            ret.colour = G.C.BLACK
        end
        return ret
    end
}