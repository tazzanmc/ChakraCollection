CHAK_UTIL.ChakraBooster {       -- Chakra Pack
    key = 'chakra_pack_normal', --key
    atlas = 'Boosters',         --atlas
    pos = { x = 0, y = 0 },     --position in atlas
    loc_txt = {                 -- local text
        name = 'Chakra Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_edition}Chakra{} cards to',
            'be used immediately'
        }
    },
    cost = 4,
    weight = 1,
    config = {
        extra = 2,
        choose = 1
    }
}