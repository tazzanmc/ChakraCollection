SMODS.Sticker{
    key = 'ethereal',
    atlas = 'Stickers',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Ethereal', --name of card
        label = 'Ethereal',
        text = { --text of card
            '{C:attention}Destroys{} itself when',
            'you enter the shop,',
            'always has {C:money}$0{} sell value'
        }
    },
    discovered = true,
    badge_colour = G.C.CHAK_STICKER_ETHEREAL,
    should_apply = function(self, card, center, area, bypass_roll)
        return G.GAME.modifiers.enable_etheral_in_shop
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card.cost = 1
        card.sell_cost = 0
        if card.ability.eternal then 
            card:remove_sticker('eternal') 
        end
        if card.ability.perishable then 
            card:remove_sticker('perishable') 
        end
        if G.GAME.modifiers.omicron == true and card.config.center.rarity ~= "chak_Token" and not (card.edition and card.edition.negative) then
            card:set_edition({negative = true})
            card.cost = 1
            card.sell_cost = 0
        end
    end,
    calculate = function(self, card, context)
        if G.GAME.modifiers.omicron == true and card.config.center.rarity ~= "chak_Token" and not (card.edition and card.edition.negative) then
            card:set_edition({negative = true})
            card.cost = 1
            card.sell_cost = 0
        end
        if context.starting_shop and not context.repetition and not context.individual then
            for i=#G.jokers.cards, 1, -1 do
                if G.jokers.cards[i].config.center.key == 'j_chak_etheric_joker' and not G.jokers.cards[i].getting_sliced then
                    card = G.jokers.cards[i]
                end
            end
            SMODS.destroy_cards(card)
            return {
                message = 'Boo!',
                colour = G.C.CHAK_ETHEREAL
            }
        end
    end
}