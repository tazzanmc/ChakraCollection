SMODS.Sticker{
    key = 'awakened',
    atlas = 'Stickers',
    pos = { x = 2, y = 0 },
    loc_txt = {
        name = 'Awakened', --name of card
        label = 'Awakened',
        text = { --text of card
            '{C:chak_sticker_awakened,E:1}Improved{}',
            'effectiveness'
        }
    },
    discovered = true,
    badge_colour = G.C.CHAK_STICKER_AWAKENED,
    rate = 0,
    apply = function(self, card, val)
        -- Case-by-case exceptions
        if card.ability.name == "Canio" or card.ability.name == "Hologram" or card.ability.name == "Constellation" or card.ability.name == "Vampire" or card.ability.name == "Madness" or card.ability.name == "Obelisk" or card.ability.name == "Campfire" or card.ability.name == "Lucky Cat" or card.ability.name == "Glass Joker" or card.ability.name == "Hit the Road" then 
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                keywords = {
                    extra = true
                }
            })
        elseif card.ability.name == "Loyalty Card" or card.ability.name == "Ramen" or card.ability.name == "Bloodstone" or card.ability.name == "Yorick" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                keywords = {
                    Xmult = true
                }
            })
        elseif card.ability.name == "Bootstraps" or card.ability.name == "Popcorn" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                keywords = {
                    mult = true
                }
            })
        elseif card.ability.name == "Invisible Joker" or card.ability.name == "Space Joker" or card.ability.name == "Business Card" or card.ability.name == "Hallucination" or card.ability.name == "Reserved Parking" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 0.5,
                keywords = {
                    extra = true
                }
            })
        elseif card.ability.name == "Ice Cream" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                keywords = {
                    chips = true
                }
            })
        elseif card.ability.name == "Rocket" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                keywords = {
                    increase = true
                }
            })
        elseif card.ability.name == "Troubadour" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 0,
                keywords = {
                    h_plays = true
                }
            })
        elseif card.ability.name == "Turtle Bean" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 0,
                keywords = {
                    h_mod = true
                }
            })
        elseif card.ability.key == "chak_derk" or card.ability.key == "chak_earth" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                unkeywords = {
                    odds = true
                }
            })
        elseif card.ability.key == "chak_mox_lotus" then
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                unkeywords = {
                    increase = true
                }
            })
        else -- Every other Joker, tries to offer some protection/general application
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 2,
                x_protect = true,
                unkeywords = {
                    odds = true,
                    size = true,
                    h_size = true,
                    increase = true,
                    ranks = true,
                    targets = true,
                    destroyed = true,
                    counterfeit_money = true,
                    every = true,
                    remaining = true,
                    faces = true,
                    per_chips = true
                }
            })
            CHAK_UTIL.mod_card_values(card.ability,{
                multiply = 0.5,
                keywords = {
                    odds = true,
                    cost = true
                }
            })
        end
        card.ability[self.key] = val
        print(card.ability)
    end
}