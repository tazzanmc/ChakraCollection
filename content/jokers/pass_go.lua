SMODS.Joker{ -- xMult if skip both small+big blind
    key = 'pass_go', --joker key
    loc_txt = { -- local text
        name = 'Pass Go',
        text = {
            "When {C:attention}Small Blind{} and {C:attention}Big Blind{}",
            "are skipped, gain {X:mult,C:white} X#1# {} Mult",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 2, y = 1},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 2.5,
            blinds_skipped = 0,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
	end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            card.ability.extra.blinds_skipped = card.ability.extra.blinds_skipped + 1
			return {
				message = card.ability.extra.blinds_skipped.."/2",
				colour = G.C.FILTER,
				card = card
			}
        end
        if context.setting_blind and not context.blueprint then
            if context.blind.boss then
                if card.ability.extra.blinds_skipped >= 2 then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                    card.ability.extra.blinds_skipped = 0
                    return {
                        message = "Collected!",
                        colour = G.C.GREEN,
                        sound = 'polychrome1', volume = 0.7, pitch = 1.2,
                        card = card
                    }
                else
                    card.ability.extra.blinds_skipped = 0
                    return {
                        message = "Jail!",
                        colour = G.C.MULT,
                        sound = 'cancel', volume = 1, pitch = 0.9,
                        card = card
                    }
                end
            else
                card.ability.extra.blinds_skipped = 0
                return {
                    message = card.ability.extra.blinds_skipped.."/2",
                    colour = G.C.MULT,
                    sound = 'cancel', volume = 1, pitch = 0.9,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                card = card,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}