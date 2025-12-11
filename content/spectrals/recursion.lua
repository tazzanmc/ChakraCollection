SMODS.Consumable { -- Add black seal to 1 selected card
    key = 'recursion',
    loc_txt = {
        name = 'Recursion', --name of card
        text = { --text of card
            "Add a {C:chak_grey}Black Seal{}",
            "to {C:attention}#1#{} selected card",
            "in your hand"
        }
    },
    set = "Spectral",
    atlas = 'MiscConsumables',
    pos = { x = 2, y = 0 },
    config = {
        extra = {
            max_highlighted = 1 --configurable value
        }
    },
    loc_vars = function(self,info_queue, center)
        info_queue[#info_queue+1] = G.P_SEALS.chak_black_seal
        return {vars = {center.ability.extra.max_highlighted }} 
    end,
    can_use = function(self,card)
            if G and G.hand then
                if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted then --if cards highlighted are above 0 but below the configurable value then
                    return true
                end
            end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do 
            CHAK_UTIL.use_consumable_animation(card, G.hand.highlighted[i], function()
                    --for every card highlighted
                    G.hand.highlighted[i]:set_seal('chak_black_seal', nil, true)
                    --set seal
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    play_sound('gold_seal', 1.2, 0.4)
                    return true
                end
            )
        end
    end
}