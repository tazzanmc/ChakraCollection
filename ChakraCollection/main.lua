--- STEAMODDED HEADER
--- MOD_NAME: Chakra Collection
--- MOD_ID: CHAKRACOLLECTION
--- MOD_AUTHOR: [tazzan]
--- MOD_DESCRIPTION: A mod that adds a new consumable card type themed around Chakras, with supporting Jokers, Vouchers, and mechanics.
--- PREFIX: chak
----------------------------------------------
------------MOD CODE -------------------------

-- ATLAS --

SMODS.Atlas{
  key = 'Jokers', --atlas key
  path = 'jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
  px = 71, --width of one card
  py = 95 -- height of one card
}
SMODS.Atlas{
    key = 'Chakras', --atlas key
    path = 'chakras.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 63, --width of one card
    py = 93 -- height of one card
  }
SMODS.Atlas{
    key = 'Boosters', --atlas key
    path = 'boosters.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
  }

-- JOKERS --

SMODS.Joker{
    key = 'dragon_balls', --joker key
    loc_txt = { -- local text
        name = 'Wish Orbs',
        text = {
            "Retrigger all {C:attention}7's{}",
            '{C:attention}2{} additional times'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 9, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = {
        extra = {
            repetitions = 2
        }
    },
    calculate = function(self, card, context)
        if context.repetition and context.other_card:get_id() == 7 then
            return {
                card = card,
                message = 'Again!',
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}

SMODS.Joker{
    key = 'last_laugh', --joker key
    loc_txt = { -- local text
        name = 'Last Laugh',
        text = {
          'Gains {X:mult,C:white}x1{} Mult per Joker',
          '{C:attention}destroyed{} this run',
          '{C:inactive}(Currently{} {X:mult,C:white}x#1#{} {C:inactive}Mult){}'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = { 
        extra = {
          Xmult = 1 --configurable value
        }
      },
      loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,
}

SMODS.Joker{
    key = 'unending_torment', --joker key
    loc_txt = { -- local text
        name = 'Unending Torment',
        text = {
          'Creates a copy of {C:spectral}Spectral{}',
          'cards used from',
          '{C:attention}Booster Packs{}'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 0, y = 1},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    calculate = function(self,card,context)
        if context.using_consumeable then
            card = card
            if card.ability.set == 'Spectral' then
                return {
                    card = copy_card(G.hand.highlighted[1]),
                    G.consumeables:emplace(card) 
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'counterfeit_joker', --joker key
    loc_txt = { -- local text
        name = 'Counterfeit Joker',
        text = {
          'Gain {C:gold}$7{} if you leave',
          'a shop {C:attention}without gaining{}',
          '{C:attention}or losing money{}'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 2, y = 0},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            money = 7,
            counterfeit_money = 0,
        },
    },
    calculate = function(self,card,context)
        if context.starting_shop then
            card.ability.extra.counterfeit_money = G.GAME.dollars
            return {
                message = "$" .. card.ability.extra.counterfeit_money,
            }
        end
        if context.ending_shop and card.ability.extra.counterfeit_money == G.GAME.dollars then
            return {
                card = card,
                dollars = card.ability.extra.money
            }
        end
    end
}

SMODS.Joker{
    key = 'copy_cat', --joker key
    loc_txt = { -- local text
        name = 'Copy Cat',
        text = {
          '{C:mult}+4{} Mult per other {C:attention}Joker{}',
          'ability triggered'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 1, y = 1},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = { 
        extra = {
            mult = 4 --configurable value
        }
    },
    calculate = function(self, card, context)
        if context.post_trigger and context.cardarea == G.jokers then
            return {
                card = card,
                mult_mod = card.ability.extra.mult,
                message = '+' .. card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker{
    key = 'etheric_joker', --joker key
    loc_txt = { -- local text
        name = 'Etheric Joker',
        text = {
          'Will always be destroyed',
          '{C:attention}first{} by random Joker',
          'destruction effects'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 0},
    soul_pos = {x = 3, y = 1},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 1, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
}

SMODS.Joker{
    key = 'celestialite', --joker key
    loc_txt = { -- local text
        name = 'Celestialite',
        text = {
          'When selecting a {C:attention}Blind{},',
          'get a copy of that',
          "Blind's {C:attention}Skip Tag{}"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 4, y = 0},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
}

SMODS.Joker{
    key = 'roffle_joker', --joker key
    loc_txt = { -- local text
        name = 'ROFL',
        text = {
            "When {C:attention}Small Blind{} or {C:attention}Big Blind{}",
            "is selected, gain {X:mult,C:white} X#1# {} Mult",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 3, y = 0},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 0.25,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
	end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blind.boss and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.MULT,
				card = card
			}
        end
        if context.joker_main then
            return {
                card = card,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker{
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
        if context.setting_blind then
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

SMODS.Joker{
    key = 'poop_butt', --joker key
    loc_txt = { -- local text
        name = 'Poop Butt',
        text = {
          '{C:mult}+#1#{} Mult when scoring',
          '{C:attention}first{} scored card. Gains',
          '{C:mult}+#2#{} Mult per round played.'
        }
    },
    atlas = 'Jokers', --atlas' key
    pos = {x = 5, y = 0},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    config = {
        extra = {
            mult = 4,
            mult_gain = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
    calculate = function(self, card, context)
        if context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] then
                return {
                    card = card,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
        if context.cardarea == G.jokers then
            if context.end_of_round and not context.blueprint then 
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain 
                return {
                    card = card,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain } },
                    colour = G.C.IMPORTANT
                }
            end
        end
    end
}

-- CONSUMABLES --

SMODS.ConsumableType{
  key = 'ChakraConsumableType', --consumable type key

  collection_rows = {3,4}, --amount of cards in one page
  primary_colour = G.C.CHAKRA_EDITION, --first color
  secondary_colour = G.C.CHAKRA_EDITION, --second color
  loc_txt = {
      collection = 'Chakra Cards', --name displayed in collection
      name = 'Chakra', --name displayed in badge
      undiscovered = {
          name = 'Hidden Chakra', --undiscovered name
          text = {'Chakra undisovered'} --undiscovered text
      }
  },
  shop_rate = 0, --rate in shop out of 100
}

SMODS.UndiscoveredSprite{
  key = 'ChakraConsumableType', --must be the same key as the consumabletype
  atlas = 'Chakras',
  pos = {x = 3, y = 1}
}

-- CHAKRA CARDS

SMODS.Consumable{
  key = 'root_chakra', --key
  set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
  atlas = 'Chakras', --atlas
  pos = {x = 0, y = 0}, --position in atlas
  loc_txt = {
      name = 'Root', --name of card
      text = { --text of card
          'Add {C:edition,E:2}Eternal{} to',
          '{C:attention}1{} selected Joker'
      }
  },
  config = {
      extra = {
          jokersselected = 1, --configurable value
      }
  },
  loc_vars = function(self,info_queue, center)
      info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
      return {vars = {center.ability.extra.jokersselected}} --displays configurable value: the #1# in the description is replaced with the configurable value
  end,
  can_use = function(self,card)
      if G and G.jokers then
          if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then --if cards in jokers highlighted are above 0 but below the configurable value then
              return true
          end
      end
      return false
  end,
  use = function(self,card,area,copier)
      for i = 1, #G.jokers.highlighted do 
          --for every card in jokers highlighted

          G.jokers.highlighted[i]:set_eternal(true)
          --set to eternal
      end

  end,  
}

SMODS.Consumable{
  key = 'sacral_chakra', --key
  set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
  atlas = 'Chakras', --atlas
  pos = {x = 1, y = 0}, --position in atlas
  loc_txt = {
      name = 'Sacral', --name of card
      text = { --text of card
          'Add {C:dark_edition}Foil{} to',
          '{C:attention}#1#{} selected Joker'
      }
  },
  config = {
      extra = {
          jokersselected = 1, --configurable value
      }
  },
  loc_vars = function(self,info_queue, center)
      info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
      return {vars = {center.ability.extra.jokersselected}} --displays configurable value: the #1# in the description is replaced with the configurable value
  end,
  can_use = function(self,card)
      if G and G.jokers then
          if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then --if cards in jokers highlighted are above 0 but below the configurable value then
              return true
          end
      end
      return false
  end,
  use = function(self,card,area,copier)
      for i = 1, #G.jokers.highlighted do 
          --for every card in jokers highlighted

          G.jokers.highlighted[i]:set_edition({foil = true},true)
          --set their edition to foil
      end

  end,
}

SMODS.Consumable{
    key = 'solar_plexus_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Chakras', --atlas
    pos = {x = 2, y = 0}, --position in atlas
    loc_txt = {
        name = 'Solar Plexus', --name of card
        text = { --text of card
            '{C:dark_edition}Ignite{} {C:attention}1{} selected Joker.'
        }
    },
    config = {
        extra = {
            jokersselected = 1, --configurable value
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_chak_ignited
    end,
    can_use = function(self,card)
        if G and G.jokers then
            if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.jokersselected then --if cards in jokers highlighted are above 0 but below the configurable value then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.jokers.highlighted do 
            --for every card in jokers highlighted
  
            G.jokers.highlighted[i]:set_edition({chak_ignited = true},true)
            --set their edition to foil
        end
  
    end,
}

SMODS.Consumable{
    key = 'heart_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Chakras', --atlas
    pos = {x = 3, y = 0}, --position in atlas
    loc_txt = {
        name = 'Heart', --name of card
        text = { --text of card
            '{C:red}Destroy{} {C:attention}1{} selected Joker,',
            'replacing it with a random Joker',
            '{C:inactive}(including{} {C:purple,E:1}Legendary{} {C:inactive}Jokers){}'
        }
    },
}

SMODS.Consumable{
    key = 'throat_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Chakras', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Throat', --name of card
        text = { --text of card
            '{C:green}1 in 2{} chance to {C:attention{}remove',
            '{C:edition,E:2}Eternal{}, {C:edition,E:2}Rental{} and/or',
            '{C:edition,E:2}Perishable{} from 1 selected Joker'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
    end,
}

SMODS.Consumable{
    key = 'third_eye_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Chakras', --atlas
    pos = {x = 1, y = 1}, --position in atlas
    loc_txt = {
        name = 'Third Eye', --name of card
        text = { --text of card
            'Creates a {C:dark_edition}Negative{},',
            '{C:edition,E:2}Ethereal{} copy of',
            '{C:attention}1{} selected Joker',
            '{C:inactive,s:0.8}(Disables itself when',
            '{C:inactive,s:0.8}you enter the shop,',
            '{C:inactive,s:0.8}always has $0 sell value)'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {key = 'chak_ethereal', set = 'Other'}
    end,
}   

SMODS.Consumable{
    key = 'crown_chakra', --key
    set = 'ChakraConsumableType', --the set of the card: corresponds to a consumable type
    atlas = 'Chakras', --atlas
    pos = {x = 2, y = 1}, --position in atlas
    loc_txt = {
        name = 'Crown', --name of card
        text = { --text of card
            'Add a random',
            '{C:red,E:2}Joker Seal{} to',
            '{C:attention}1{} selected Joker'
        }
    },
}

-- BOOSTERS --

SMODS.ConsumableType{
    key = 'ChakraBoosterType', --consumable type key
    collection_rows = {4}, --amount of cards in one page
    primary_colour = G.C.CHAKRA_EDITION, --first color
    secondary_colour = G.C.CHAKRA_EDITION, --second color
    loc_txt = {
        collection = 'Chakra Packs', --name displayed in collection
        name = 'Chakra', --name displayed in badge
        undiscovered = {
            name = 'Hidden Chakra Pack', --undiscovered name
            text = {'Chakra Pack undisovered'} --undiscovered text
        }
    },
    shop_rate = 0, --rate in shop out of 100
  }

SMODS.Booster{
    key = 'chakra', --key
    group_key= 'ChakraBoosters', --group key
    set = 'ChakraBoosterType',
    atlas = 'Boosters', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = { -- local text
      name = 'Chakra Pack',
      text = {
        'Choose {C:attention}1{} of up to',
        '{C:attention}2{} {C:green}Chakra{} cards to',
        'be used immediately'
        }
    },
    cost = 4,
    kind = 'ChakraBooster',
    config = {
        extra = 2,
        choose = 1
    },
}

SMODS.Booster{
    key = 'chakra_jumbo', --key
    group_key= 'ChakraBoosters', --group key
    set = 'ChakraBoosterType',
    atlas = 'Boosters', --atlas
    pos = {x = 1, y = 0}, --position in atlas
    loc_txt = { -- local text
      name = 'Chakra Pack',
      text = {
        'Choose {C:attention}1{} of up to',
        '{C:attention}2{} {C:green}Chakra{} cards to',
        'be used immediately'
        }
    },
    cost = 4,
    kind = 'ChakraBooster',
    config = {
        extra = 2,
        choose = 1
    },
}

SMODS.Booster{
    key = 'chakra_mega', --key
    group_key= 'ChakraBoosters', --group key
    set = 'ChakraBoosterType',
    atlas = 'Boosters', --atlas
    pos = {x = 2, y = 0}, --position in atlas
    loc_txt = { -- local text
      name = 'Chakra Pack',
      text = {
        'Choose {C:attention}1{} of up to',
        '{C:attention}2{} {C:green}Chakra{} cards to',
        'be used immediately'
        }
    },
    cost = 4,
    kind = 'ChakraBooster',
    config = {
        extra = 2,
        choose = 1
    },
}

SMODS.Booster{
    key = 'chakra_single', --key
    group_key= 'ChakraBoosters', --group key
    set = 'ChakraBoosterType',
    atlas = 'Boosters', --atlas
    pos = {x = 3, y = 0}, --position in atlas
    loc_txt = { -- local text
      name = 'Chakra Pack',
      text = {
        'Choose {C:attention}1{} of up to',
        '{C:attention}2{} {C:green}Chakra{} cards to',
        'be used immediately'
        }
    },
    cost = 4,
    kind = 'ChakraBooster',
    config = {
        extra = 2,
        choose = 1
    },
}

-- EDITIONS --
SMODS.Edition{
    key = 'ignited',
    shader = false,
    loc_txt = {
        name = 'Ignited', --name of card
        label = 'Ignited',
        text = { --text of card
            '{C:attention}Retriggers{} itself, {C:green}1 in 6',
            'chance this card is {C:red}destroyed',
            'at end of round'
        }
    },
    sound = {
        sound = "cardFan2", per = 1.2, vol = 0.4
    },
    config = {
        extra = {
            odds = 6
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (G.GAME.probabilities.normal or 1),
                card.ability.extra.odds
            }
        }
    end,
    calculate = function(self, card, context)
        if context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = self
            }
        end
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
                -- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
            if pseudorandom('ignited') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    -- This part plays the animation.
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                            -- This part destroys the card.
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = 'Extinguished!'
                }
            else
                return {
                    message = 'Safe!'
                }
            end
        end
    end,
}

-- JOKER DISPLAY
if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end

----------------------------------------------
------------MOD CODE END----------------------