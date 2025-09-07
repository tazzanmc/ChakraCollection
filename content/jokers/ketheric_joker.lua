SMODS.Joker{ -- Spawn token etheric joker
    key = 'ketheric_joker', --joker key
    loc_txt = { -- local text
        name = 'Ketheric Joker',
        text = {
          'When selecting a blind,',
          'create a {C:chak_token}Token {C:attention}Etheric',
          "{C:attention}Joker{} if you don't have one"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 9, y = 1},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 3, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            joker_key = 'j_chak_etheric_joker',
            has_etheric = 0
        },
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_chak_etheric_joker
    end,
    calculate = function(self,card,context)
        if context.setting_blind and context.cardarea == G.jokers then
            card.ability.extra.has_etheric = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.key == card.ability.extra.joker_key and (G.jokers.cards[i].edition and G.jokers.cards[i].edition.negative) then
                    card.ability.extra.has_etheric = 1
                end
            end
            if card.ability.extra.has_etheric == 0 then
                SMODS.add_card {
                    area = G.jokers,
                    key = card.ability.extra.joker_key
                }
                return {
                    message = 'Summoned!',
                    colour = G.C.SECONDARY_SET.Spectral,
                }
            end
        end
    end
}