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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_fragile', set = 'Other'}
        return { vars = { G.GAME.last_destroyed_card_value or 'None', G.GAME.last_destroyed_card_suit or 'None', colours = { G.C.SUITS[G.GAME.last_destroyed_card_suit or 'spades'] } } }
    end,
    calculate = function(self,card,context)
        if context.remove_playing_cards and not context.blueprint then
            local removed = context.removed[#context.removed]
            return {
                message = removed.base.name,
                colour = G.C.FILTER
            }
        end
        if context.first_hand_drawn and G.GAME.last_destroyed_card_id ~= nil and G.GAME.last_destroyed_card_suit ~= nil then
            local created_card = SMODS.add_card{
                set = "Playing Card",
                no_edition = true,
                edition = G.GAME.last_destroyed_card_edition,
                enhancement = G.GAME.last_destroyed_card_enhancement,
                seal = G.GAME.last_destroyed_card_seal,
                rank = G.GAME.last_destroyed_card_value,
                suit = G.GAME.last_destroyed_card_suit
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