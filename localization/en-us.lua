return {
    descriptions = {
        Edtion = {
            e_chak_ignited = {
                name = "Ignited",
                text = {
                    'Retriggers itself, {C:green,s:0.8}#1# in #2#',
                    'chance this card is {C:red}destroyed',
                    'at end of round'
                }
            }
        },
        Stake = {
            stake_chak_ethereal_stake = {
                name = "Ethereal Stake",
                text = {
                    "Shop can have {C:chak_sticker_ethereal,E:2}Ethereal{} Jokers",
                    "{C:inactive,s:0.7}({C:attention,s:0.7}Destroys{C:inactive,s:0.7} itself when you enter the shop,",
                    "{C:inactive,s:0.7}always has {C:money,s:0.7}$0{C:inactive,s:0.7} sell value)",
                    "{s:0.7}Applies all previous Stakes",
                },
            },
        },
        Other = {
            chak_ethereal_stake_sticker = {
                name = "Ethereal Sticker",
                text = {
                    "Used this Joker",
                    "to win on {C:chak_sticker_ethereal,E:2}Ethereal",
                    "{C:chak_sticker_ethereal,E:2}Stake{} difficulty"
                }
            },
            chak_token_joker = {
                name = "Token",
                text = {
                    '{C:dark_edition}+1{} Joker slot'
                }
            }
        }
    },
    misc = {
        dictionary = {
            chak_chakra_pack = "Chakra Pack",
            k_chak_token = "Token",
            k_chips = "Chips"
        },
        labels = {
            chak_token = "Token",
        },
        v_dictionary = {
            chak_a_discards = "+#1# Discards",
            chak_a_discards_minus = "-#1# Discards",
            chak_a_hands_minus = "-#1# Hands",
        }
    }
}