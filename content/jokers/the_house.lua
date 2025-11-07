SMODS.Joker{ -- xMult per played blind
    key = 'the_house', --joker key
    loc_txt = { -- local text
        name = 'The House',
        text = {
            "Earn {C:money}$#1#%{} of winning hand's",
            "scored chips at end of round",
            "{C:red}Lose the game{} after",
            "beating a {C:attention}Boss Blind{}"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 2},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            percent = 0.1,
            dollars = 0
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent } }
	end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.end_of_round and not context.blueprint then
            if G.GAME.blind:get_type() == "Boss" then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
                return {
                    card = card,
                    message = "The house always wins!"
                }
            else
                print(hand_chips * mult)
                print(math.min(math.ceil((hand_chips * mult or 0) * (card.ability.extra.percent / 100)), 50))
                card.ability.extra.dollars = math.min(math.ceil((hand_chips * mult or 0) * (card.ability.extra.percent / 100)), 50)
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}