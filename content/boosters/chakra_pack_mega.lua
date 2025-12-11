CHAK_UTIL.ChakraBooster {     -- Mega Chakra Pack
    key = 'chakra_pack_mega', --key
    atlas = 'Boosters',       --atlas
    pos = { x = 2, y = 0 },   --position in atlas
    loc_txt = {               -- local text
        name = 'Mega Chakra Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_edition}Chakra{} cards to',
            'be used immediately'
        }
    },
    cost = 8,
    weight = 0.25,
    config = {
        extra = 4,
        choose = 2
    }
}