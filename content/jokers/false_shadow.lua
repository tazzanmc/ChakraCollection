SMODS.Joker{ -- +$ equal to destroyed joker's rarity
    key = 'false_shadow', --joker key
    loc_txt = { -- local text
        name = 'False Shadow',
        text = {
          'Upon exiting the shop, create',
          'a {C:dark_edition}Negative{}, {C:chak_sticker_ethereal,E:2}Ethereal{} copy',
          "of the last destroyed {C:attention}Joker",
          "{C:inactive}(Currently: {C:attention}#1#{C:inactive})"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 3},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            copying = nil,
        },
    },
    loc_vars = function(self, info_queue, card)
        local copying = G.GAME.last_destroyed_joker
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
        if copying ~= nil then
            info_queue[#info_queue + 1] = G.P_CENTERS[copying]
        end
        return { vars = { copying and G.localization.descriptions.Joker[copying].name or "None" } }
    end,
    calculate = function(self,card,context)
        if context.joker_type_destroyed and context.cardarea == G.jokers and not context.blueprint then
            G.GAME.last_destroyed_joker = context.card.config.center_key
            sendDebugMessage("copying:" .. G.GAME.last_destroyed_joker, "CHAK")
            return {
                message = G.localization.descriptions.Joker[G.GAME.last_destroyed_joker].name or "None",
                colour = G.C.FILTER
            }
        end
        if context.ending_shop and G.GAME.last_destroyed_joker ~= nil then
            local copying = G.GAME.last_destroyed_joker
            if G.P_CENTERS[copying].rarity == "chak_Token" then
                local copied_joker = SMODS.add_card {
                    area = G.jokers,
                    key = copying
                }
                copied_joker:add_sticker('chak_ethereal', true)
            else
                local copied_joker = SMODS.add_card {
                    area = G.jokers,
                    key = copying
                }
                copied_joker:set_edition({negative = true})
                copied_joker:add_sticker('chak_ethereal', true)
            end
            return {
                message = "Copied!",
                colour = G.C.CHAK_ETHEREAL,
            }
        end
    end
}