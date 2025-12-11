CHAK_UTIL.ChakraBooster {      -- Jumbo Chakra Pack
    key = 'chakra_pack_jumbo', --key
    atlas = 'Boosters',        --atlas
    pos = { x = 1, y = 0 },    --position in atlas
    loc_txt = {                -- local text
        name = 'Jumbo Chakra Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_edition}Chakra{} cards to',
            'be used immediately'
        }
    },
    cost = 6,
    weight = 1,
    config = {
        extra = 4,
        choose = 1
    }
}