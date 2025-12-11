CHAK_UTIL.ChakraBooster {       -- Single Chakra Pack
    key = 'chakra_pack_single', --key
    atlas = 'Boosters',         --atlas
    pos = { x = 3, y = 0 },     --position in atlas
    loc_txt = {                 -- local text
        name = 'Single Chakra Pack',
        text = {
            'Choose {C:attention}#1#{}',
            '{C:chak_edition}Chakra{} card to',
            'be used immediately'
        }
    },
    cost = 2,
    weight = 0,
    config = {
        extra = 1,
        choose = 1
    },
    in_pool = function(self, args) -- Don't appear
        return false
    end  
}