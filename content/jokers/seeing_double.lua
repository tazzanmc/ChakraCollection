SMODS.Joker{ -- Open skipped pack once per round
    key = 'seeing_double', --joker key
    loc_txt = { -- local text
        name = 'Seeing Double',
        text = {
          "{C:attention}Skipping{} a Booster Pack opens",
          "another Booster Pack of the",
          "{C:attention}same type{} #1# opens per round"
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
            max_opens = 1,
            opens = 1,
            booster = ""
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.max_opens } }
    end,
    calculate = function(self,card,context)
        if context.open_booster and not context.blueprint then
            card.ability.extra.booster = context.card.config.center.key
            print(card.ability.extra.booster)
        end
        if context.skipping_booster and card.ability.extra.opens > 0 and not context.blueprint then
            card.ability.extra.opens = card.ability.extra.opens - 1
            CHAK_UTIL.open_booster_pack_from_tag(card.ability.extra.booster)
            return {
                message = "Again!",
                colour = G.C.FILTER
            }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition and not context.individual and not context.blueprint then
            card.ability.extra.opens = card.ability.extra.max_opens
            return {
                message = "Refreshed!",
                colour = G.C.FILTER
            }
        end
    end,
    in_pool = function(self, args) -- Don't appear while this joker's broken
        return false
    end
}