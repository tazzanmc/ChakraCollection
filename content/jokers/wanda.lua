SMODS.Joker { -- 100 chips, lose 15 per discard. Reset after beating boss
    key = "wanda",
    loc_txt = {
        name = "Wanda",
        text = {
            "{C:chips}+#1#{} Chips. Loses {C:chips}-#2#",
            "Chips each discard",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 7},
    config = {
        extra = {
            chip_loss = 15,
            chips = 100
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_loss } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_loss
            return {
                colour = G.C.BLUE,
                message = "Downgraded!"
            }
        end
        if context.joker_main then
            if card.ability.extra.chips ~= 0 then 
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
        if context.cardarea == G.jokers and context.end_of_round and G.GAME.blind:get_type() == "Boss" and not context.blueprint then
            card.ability.extra.chips = 100
            return {
                colour = G.C.FILTER,
                message = "Reset!"
            }
        end
    end
}