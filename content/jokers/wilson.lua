SMODS.Joker { -- Gain mult for each pair in played hand. Reset after beating boss
    key = "wilson",
    loc_txt = {
        name = "Wilson",
        text = {
            "Gains {C:mult}+#1#{} Mult for",
            "each {C:attention}Pair{} in played hand",
            "{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)",
            "{C:inactive,s:0.8}({C:attention,s:0.8}Resets {C:inactive,s:0.8}after defeating a Boss Blind)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 6},
    config = {
        extra = {
            mult_gain = 3,
            mult = 0,
            ranks = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local rank_pairs = 0
            card.ability.extra.ranks = {}
            for _, playing_card in ipairs(context.full_hand) do
                if card.ability.extra.ranks[playing_card:get_id()] then
                    rank_pairs = rank_pairs + 1
                    print("Another" .. playing_card:get_id() .. "found. Pairs now" .. rank_pairs)
                else
                    card.ability.extra.ranks[playing_card:get_id()] = true
                    print("Logged" .. playing_card:get_id())
                end
            end
            if rank_pairs ~= 0 then
                card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_gain * rank_pairs)
                return {
                    colour = G.C.RED,
                    message = "Upgraded!"
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.mult ~= 0 then 
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
        if context.cardarea == G.jokers and context.end_of_round and G.GAME.blind:get_type() == "Boss" and not context.blueprint then
            card.ability.extra.mult = 0
            return {
                colour = G.C.FILTER,
                message = "Reset!"
            }
        end
    end
}