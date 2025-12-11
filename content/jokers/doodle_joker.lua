SMODS.Joker{ -- Destroy right Joker and replace it with rand Joker of rarity
    key = 'doodle_joker', --joker key
    loc_txt = { -- local text
        name = 'Doodle Joker',
        text = {
          "When {C:attention}Blind{} is selected,",
          "destroy Joker to the right",
          "and create a {C:attention}random{} Joker",
          "of its {C:attention}rarity"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 9, y = 3},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            doodle_rarity = nil
        }
    },
    calculate = function(self,card,context)
        if context.setting_blind and card.area == G.jokers then
            local right_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    if G.jokers.cards[i + 1] ~= nil then -- Ensure right Joker exists
                        right_joker = G.jokers.cards[i + 1] 
                    end
                end
            end
            if right_joker ~= nil and not right_joker.ability.eternal then -- Get right joker rarity and slice it
                right_joker.getting_sliced = true
                card.ability.extra.doodle_rarity = right_joker.config.center.rarity
                if card.ability.extra.doodle_rarity == 1 then -- Translate # rarity into string rarity for vanilla
                    card.ability.extra.doodle_rarity = "Common"
                elseif card.ability.extra.doodle_rarity == 2 then
                    card.ability.extra.doodle_rarity = "Uncommon"
                elseif card.ability.extra.doodle_rarity == 3 then
                    card.ability.extra.doodle_rarity = "Rare"
                elseif card.ability.extra.doodle_rarity == 4 then
                    card.ability.extra.doodle_rarity = "Legendary"
                end
                print(card.ability.extra.doodle_rarity)
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        -- See note about SMODS Scaling Manipulation on the wiki
                        card:juice_up(0.8, 0.8)
                        right_joker.getting_sliced()
                        right_joker:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({ -- Create new Joker
                    func = function()
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = card.ability.extra.doodle_rarity,
                            key_append = 'chak_doodle_joker',
                            allow_duplicates = false
                        }
                        return true
                    end
                }))
                return {
                    message = "Doodled!",
                    colour = G.C.CHAK_TOKEN
                }
            end
        end
    end
}