SMODS.Joker{ -- Spawn token jokers
    key = 'token_machine', --joker key
    loc_txt = { -- local text
        name = 'Token Machine',
        text = {
            "Create a random {C:chak_sticker_ethereal,E:2}Ethereal",
            "{C:chak_token}Token{} Joker each round"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 4},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local evoked_joker = nil 
                    evoked_joker = SMODS.add_card {
                        set = 'Joker',
                        rarity = 'chak_Token',
                        key_append = 'chak_token_machine',
                        allow_duplicates = false
                    }
                    evoked_joker:add_sticker('chak_ethereal', true) -- Have to use add_sticker because 'stickers =' from add_card dont work with ethereal
                    return true
                end
            }))
            return {
                message = 'Dispensed!',
                colour = G.C.CHAK_TOKEN,
            }
        end
    end,
}