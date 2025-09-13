SMODS.Joker{ -- Spawn common, uncommon, rare, negative, ethereal jokers
    key = 'evoker', --joker key
    loc_txt = { -- local text
        name = 'Evoker',
        text = {
            "Create a random {C:blue}Common{},",
            "{C:green}Uncommon{}, and {C:red}Rare",
            "Joker each round, all",
            "{C:dark_edition}Negative{} and {C:chak_sticker_ethereal,E:2}Ethereal"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 7, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local evoked_joker = nil 
                    evoked_joker = SMODS.add_card {
                        set = 'Joker',
                        rarity = 'Common',
                        key_append = 'chak_evoker',
                        edition = 'e_negative',
                        allow_duplicates = false
                    }
                    evoked_joker:add_sticker('chak_ethereal', true) -- Have to use add_sticker because 'stickers =' from add_card dont work with ethereal
                    evoked_joker = SMODS.add_card {
                        set = 'Joker',
                        rarity = 'Uncommon',
                        key_append = 'chak_evoker',
                        edition = 'e_negative',
                        allow_duplicates = false
                    }
                    evoked_joker:add_sticker('chak_ethereal', true)
                    evoked_joker = SMODS.add_card {
                        set = 'Joker',
                        rarity = 'Rare',
                        key_append = 'chak_evoker',
                        edition = 'e_negative',
                        allow_duplicates = false
                    }
                    evoked_joker:add_sticker('chak_ethereal', true)
                    return true
                end
            }))
            return {
                message = 'Summoned!',
                colour = G.C.CHAK_ETHEREAL,
            }
        end
    end,
}