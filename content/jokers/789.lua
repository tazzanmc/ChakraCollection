SMODS.Joker { -- Scored 7's X2 mult if played w/ 9, destroy random scored 9
    key = "789",
    loc_txt = {
        name = "789",
        text = {
            "{C:attention}7's{} give {X:mult,C:white}X#1#{} Mult when",
            "scored if played hand has",
            "a scoring {C:attention}9{}. Then {C:red}destroy{}",
            "a random scoring {C:attention}9"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 4},
    config = { 
        extra = { 
            Xmult = 2,
            ranks = {
                ['7'] = 0,
                ['9'] = 0
            },
            targets = {},
            destroyed = 0
        } 
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then 
            card.ability.extra.ranks['7'] = 0 -- Reset 7 count
            card.ability.extra.ranks['9'] = 0 -- Reset 9 count
            card.ability.extra.destroyed = 0 -- Reset destroy checker
            card.ability.extra.targets = {} -- Reset destroy targets
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 7 and card.ability.extra.ranks['7'] == 0 then -- Look for scoring 7s
                    card.ability.extra.ranks['7'] = 1
                    sendDebugMessage("789: found 7", "CHAK")
                elseif context.scoring_hand[i]:get_id() == 9 and card.ability.extra.ranks['9'] == 0 then -- Look for scoring 9s
                    card.ability.extra.ranks['9'] = 1
                    sendDebugMessage("789: found 9", "CHAK")
                end
            end
            if (card.ability.extra.ranks['7'] > 0 and card.ability.extra.ranks['9'] > 0) then -- Debug msg if 789 is active
                sendDebugMessage("789: active!", "CHAK")
            end
            for i = 1, #context.scoring_hand do -- Store 9s as destroy targets
                if context.scoring_hand[i]:get_id() == 9 then
                    table.insert(card.ability.extra.targets, context.scoring_hand[i])
                end
            end
        end
        if context.individual and context.cardarea == G.play 
        and (card.ability.extra.ranks['7'] > 0 and card.ability.extra.ranks['9'] > 0) then -- If scoring 7s & 9s found
            if context.other_card:get_id() == 7 then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
        if context.destroy_card and context.cardarea == G.play and card.ability.extra.destroyed == 0 -- Mark random 9 to be destroyed
        and (card.ability.extra.ranks['7'] > 0 and card.ability.extra.ranks['9'] > 0) 
        and context.destroy_card == pseudorandom_element(card.ability.extra.targets, pseudoseed('chak_789')) then
            card.ability.extra.destroyed = 1
            return {
                remove = true,
                message = "Ate!",
                colour = G.C.FILTER
            }
        end
    end
}