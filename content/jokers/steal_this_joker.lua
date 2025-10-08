SMODS.Joker{ -- Store & dupe destroyed playing cards
    key = 'steal_this_joker', --joker key
    loc_txt = { -- local text
        name = 'Steal This Joker!',
        text = {
          "Create a {C:chak_sticker_fragile}Fragile{} copy of",
          "the last destroyed {C:attention}playing card",
          "at the beginning of the round",
          "{C:inactive}(Currently: {C:attention}#1# {C:inactive}of {V:1}#2#{C:inactive})",
          "{C:inactive,s:0.7}(Retains Enhancement, Edition, & Seal)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 6, y = 4},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pixel_size = { w = 70, h = 65 },
    config = {
        extra = {
            copying = {
                base = {
                    id = "None",
                    suit = "None",
                    value = "None"
                },
                seal = nil,
                edition = nil,
                enhancement = nil
            }
        },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_fragile', set = 'Other'}
        local copying = card.ability.extra.copying
        return { vars = { copying.base.value, copying.base.suit, colours = { G.C.SUITS[copying.base.suit] } } }
    end,
    calculate = function(self,card,context)
        local copying = card.ability.extra.copying
        if context.remove_playing_cards and not context.blueprint then
            for _, removed_card in ipairs(context.removed) do
                copying.base.id = removed_card.base.id
                copying.base.suit = removed_card.base.suit
                copying.base.value = removed_card.base.value
                if removed_card.seal ~= nil then
                    copying.seal = removed_card.seal
                else
                    copying.seal = nil
                end
                if removed_card.edition ~= nil then
                    copying.edition = removed_card.edition.key
                else
                    copying.edition = nil
                end
                if removed_card.config.center ~= nil then
                    copying.enhancement = removed_card.config.center.key
                else
                    copying.enhancement = nil
                end
            end
        end
        if context.first_hand_drawn and copying.base.id ~= "None" and copying.base.suit ~= "None" then
            local created_card = SMODS.add_card{
                set = "Playing Card",
                no_edition = true,
                edition = copying.edition,
                enhancement = copying.enhancement,
                seal = copying.seal,
                rank = copying.base.value,
                suit = copying.base.suit
            }
            created_card:add_sticker('chak_fragile', true)
            created_card.states.visible = nil -- Animate
                G.E_MANAGER:add_event(Event({
                    func = function()
                        created_card:start_materialize()
                        return true
                    end
                }))
            return {
                message = "Copied!",
                colour = G.C.FILTER,
            }
        end
    end
}