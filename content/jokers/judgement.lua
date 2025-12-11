SMODS.Joker{ -- Dupe used Spectrals from packs
    key = 'judgement', --joker key
    loc_txt = { -- local text
        name = 'Judgement',
        text = {
          "The next {C:attention}#1#{} times you use a",
          "{C:tarot}Judgement Tarot Card{}, choose",
          "between {C:attention}15{} random Jokers instead.",
          "{C:red}Self destructs{} after {C:attention}#2#{C:inactive}/{C:attention}#1#{} uses"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 8, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            max_uses = 3, --configurable value
            uses = 0
        }
    },
    loc_vars = function(self,info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_judgement
        return {vars = {card.ability.extra.max_uses, card.ability.extra.uses}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.chak_judgement = true
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.config.center.key == "c_judgement" and not context.blueprint then
            card.ability.extra.uses = card.ability.extra.uses + 1
            if card.ability.extra.uses >= card.ability.extra.max_uses then
                SMODS.destroy_cards(card)
            end
            return {
                colour = G.C.FILTER,
                message = "Hail 2 U!"
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        local has_judgement = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == "chak_judgement" then
                has_judgement = has_judgement + 1
            end
        end
        if has_judgement <= 1 then
            G.GAME.modifiers.chak_judgement = false
        end
    end
}