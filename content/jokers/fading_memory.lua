G.FUNCS.fading_memory_func = function(e)
    local card = e.config.ref_table
    local dynatext_main = e.children[1].children[1].config.object
    card.fading_memory_text = string.find(dynatext_main.string, " ") and "Chips" or "Mult"
    e.children[1].config.colour = string.find(dynatext_main.string, "X") and G.C.MULT or G.C.CLEAR
end

CHAK_UTIL.TokenJoker{ -- rand mult, rand xmult, or rand chips token
    key = 'fading_memory',
    loc_txt = {
        name = "Fading Memory"
    },
    atlas = 'Jokers',
    pos = {x = 4, y = 3 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            increase = 1,
            Xmult_min = 1.5,
            Xmult_max = 2,
            mult_min = 8,
            mult_max = 12,
            chips_min = 50,
            chips_max = 100
        }
    },
    loc_vars = function(self, info_queue, card)
        local t_Xmult = {}
        for i = card.ability.extra.Xmult_min, card.ability.extra.Xmult_max do
            t_Xmult[#t_Xmult + 1] = "X" .. tostring(i)
        end
        r_Xmult = pseudorandom_element(t_Xmult, 'chak_fading_memory_text')
        local t_mult = {}
        for i = card.ability.extra.mult_min, card.ability.extra.mult_max do
            t_mult[#t_mult + 1] = "+" .. tostring(i)
        end
        r_mult = pseudorandom_element(t_mult, 'chak_fading_memory_text')
        local t_chips = {}
        for i = card.ability.extra.chips_min, card.ability.extra.chips_max do
            t_chips[#t_chips + 1] = " +" .. tostring(i)
        end
        r_chips = pseudorandom_element(t_chips, 'chak_fading_memory_text')
        local loc_mult = ' ' .. (localize('k_mult')) .. ' '
        local loc_chips = ' ' .. (localize('k_chips')) .. ' '
        card.fading_memory_text = "Chips"
        main_start = {
            {
                n = G.UIT.R,
                config = {
                    ref_table = card,
                    func = "fading_memory_func",
                },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            colour = G.C.CLEAR,
                            r = 0.05,
                            padding = 0.03,
                            res = 0.15
                        },
                        nodes = {
                            {
                                n = G.UIT.O,
                                config = {
                                    object = DynaText({
                                        string = { { string = r_chips, colour = G.C.CHIPS }, { string = r_mult, colour = G.C.MULT }, { string = r_Xmult, colour = G.C.UI.TEXT_LIGHT } },
                                        colours = { G.C.RED },
                                        pop_in_rate = 9999999,
                                        silent = true,
                                        random_element = true,
                                        pop_delay = 0.3,
                                        scale = 0.32,
                                        min_cycle_time = 0,
                                    }),
                                },
                            }
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = {
                            colour = G.C.CLEAR,
                            r = 0.05,
                            padding = 0.03,
                            res = 0.15
                        },
                        nodes = {
                            {
                                n = G.UIT.O,
                                config = {
                                    object = DynaText({
                                        string = {
                                            { ref_table = card, ref_value = "fading_memory_text" } },
                                        colours = { G.C.UI.TEXT_DARK },
                                        pop_in_rate = 9999999,
                                        silent = true,
                                        pop_delay = 0.2011,
                                        scale = 0.32,
                                        min_cycle_time = 0
                                    })
                                }
                            }
                        }
                    },
                },
            },
        }
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
        return { main_start = main_start }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local ret = {
                "xmult",
                "mult",
                "chips"
            }
            if pseudorandom_element(ret, 'chak_fading_memory') == "xmult" then
                return {xmult = pseudorandom('chak_fading_memory', card.ability.extra.Xmult_min, card.ability.extra.Xmult_max)}
            elseif pseudorandom_element(ret, 'chak_fading_memory') == "mult" then
                return {mult = pseudorandom('chak_fading_memory', card.ability.extra.mult_min, card.ability.extra.mult_max)}
            else
                return {chips = pseudorandom('chak_fading_memory', card.ability.extra.chips_min, card.ability.extra.chips_max)}
            end
        end
    end
}