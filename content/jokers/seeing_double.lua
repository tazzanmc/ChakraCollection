SMODS.Joker{ -- Open skipped pack once per round
    key = 'seeing_double', --joker key
    loc_txt = { -- local text
        name = 'Seeing Double',
        text = {
          "{C:attention}Skipping{} a Booster Pack opens",
          "another Booster Pack of the",
          "{C:attention}same type{} #1# time per round"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 4, y = 4},
    soul_pos = {x = 4, y = 5},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            times = 1,
            time = 1,
            booster = ""
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.times } }
    end,
    calculate = function(self,card,context)
        if context.open_booster and not context.blueprint then
            card.ability.extra.booster = context.card.config.center.key
        end
        if context.skipping_booster and card.ability.extra.time > 0 and not context.blueprint then
            card.ability.extra.time = card.ability.extra.time - 1
            CHAK_UTIL.open_booster_pack(card.ability.extra.booster)
            return {
                message = "Again!",
                colour = G.C.FILTER
            }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition and not context.individual and not context.blueprint then
            card.ability.extra.time = card.ability.extra.times
            return {
                message = "Refreshed!",
                colour = G.C.FILTER
            }
        end
    end
}