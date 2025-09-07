SMODS.Joker{ -- Dupe used Spectrals
    key = 'unending_torment', --joker key
    loc_txt = { -- local text
        name = 'Unending Torment',
        text = {
          'Creates a copy of the first',
          '{C:spectral}Spectral{} card used from',
          'any {C:attention}Booster Pack{}'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 1},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            ready = 0
        }
    },
    calculate = function(self,card,context)
        if context.open_booster then
            card.ability.extra.ready = 1
        end
        if context.skipping_booster then
            card.ability.extra.ready = 0
        end
        if context.using_consumeable and card.ability.extra.ready >= 1 and context.consumeable.ability.set == 'Spectral' then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local copied_card = copy_card(context.consumeable)
                    copied_card:add_to_deck()
                    G.consumeables:emplace(copied_card) 
                    return true
                end
            }))
            card.ability.extra.ready = 0
            return { message = localize('k_duplicated_ex') } 
        end
    end
}