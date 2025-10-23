SMODS.Joker{ -- Sell to destroy right Joker, earn 2X sell val, bypass eternal
    key = 'killer_joke', --joker key
    loc_txt = { -- local text
        name = 'Killer Joke',
        text = {
          "Sell this Joker to {C:attention}destroy",
          "the Joker to the right and",
          "earn {C:money}#1#X{} its sell value",
          "{C:inactive}(Bypasses {C:chak_eternal,E:2}Eternal{C:inactive})"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 5},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            multiplier = 2,
            money = 0
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.multiplier } }
	end,
    calculate = function(self,card,context)
        if context.selling_self and card.area == G.jokers then
            local right_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    if G.jokers.cards[i + 1] ~= nil then -- Ensure right Joker exists
                        right_joker = G.jokers.cards[i + 1] 
                    end
                end
            end
            if right_joker ~= nil then -- Get right joker money and slice it
                right_joker.getting_sliced = true
                card.ability.extra.money = right_joker.sell_cost * card.ability.extra.multiplier
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        -- See note about SMODS Scaling Manipulation on the wiki
                        card:juice_up(0.8, 0.8)
                        right_joker:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        return true
                    end
                }))
                return {
                    message = "Nothin' Personal",
                    dollars = card.ability.extra.money,
                    colour = G.C.FILTER
                }
            end
        end
    end
}