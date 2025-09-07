local jd_def = JokerDisplay.Definitions -- You can assign it to a variable to use as shorthand

jd_def["j_chak_poop_butt"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    reminder_text = {
        { text = "(+" },
        { ref_table = "card.ability.extra", ref_value = "mult_gain", colour = lighten(G.C.MULT, 0.35) },
        { text = ")" }
    },
    text_config = { colour = G.C.MULT }
}

jd_def["j_chak_counterfeit_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.ability.extra", ref_value = "money"}
    },
    reminder_text = {
        { text = "($" },
        { ref_table = "card.ability.extra", ref_value = "counterfeit_money", colour = lighten(G.C.MONEY, 0.35) },
        { text = ")" }
    },
    text_config = { colour = G.C.MONEY }
}