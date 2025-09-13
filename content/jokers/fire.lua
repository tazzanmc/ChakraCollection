SMODS.Joker{ -- Hearts in hand ignite
    key = 'fire', --joker key
    loc_txt = { -- local text
        name = 'Fire',
        text = {
            '{C:dark_edition}Ignite{} a random',
            'editionless {C:hearts}Heart{} held in',
            'hand at end of round'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 2, y = 2},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_chak_ignited
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.end_of_round then
            local targets = {}
            for _, v in ipairs(G.hand.cards) do
                if v:is_suit("Hearts") and not v.edition then
                    table.insert(targets, v)
                end
            end
            if next(targets) ~= nil then
                local target = pseudorandom_element(targets, pseudoseed('chak_fire'))
                G.E_MANAGER:add_event(Event {
                trigger = 'before',
                delay = 1.0,
                func = function()
                        target:set_edition('e_chak_ignited', true)
                        target:juice_up()
                        card:juice_up()
                        return true
                    end
                })
                return {
                    message = "Ignite!",
                    colour = G.C.FILTER
                }
            end
        end
    end
}