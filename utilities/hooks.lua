---@diagnostic disable: duplicate-set-field
-- Initializes default values in the game object
-- referenced code from Paperback (go play it)
local init_game_object_ref = Game.init_game_object
function Game.init_game_object(self)
  local ret = init_game_object_ref(self)

  -- referenced code from Ortalab to get the list of secret hands
  local secrets = {}
  for k, v in pairs(ret.hands) do
    if v.visible == false then table.insert(secrets, k) end
  end

  ret.chak = {
    banned_run_keys = {},
  }
  return ret
end

-- Hook shatters (hopefuly) to also shatter Fragile
local shatters_ref = SMODS.shatters
function SMODS.shatters(card)
  local ret = shatters_ref(card)
  if card.ability.chak_fragile then
    return true 
  end
  return ret
end

-- Don't shuffle cards if you have certain Joker
local shuffle_ref = CardArea.shuffle
function CardArea:shuffle(_seed)
  local ret = shuffle_ref(self, _seed)
  if self == G.deck and G.GAME.modifiers.chak_legendary == true then
    table.sort(self.cards, function (a, b) return a:get_nominal('suit') < b:get_nominal('suit') end )
    self:set_ranks()
  end
  return ret
end

-- Collector's Edition making editions score in hand
-- thank you Somethingcom515!
local oldcalcedition = Card.calculate_edition
function Card:calculate_edition(context)
    local g
    if self.edition and (self.edition.foil or self.edition.holo or self.edition.polychrome) and context.cardarea == G.hand then
        if next(SMODS.find_card("j_chak_collectors_edition")) then
            context.cardarea = G.play
            g = oldcalcedition(self, context)
            context.cardarea = G.hand
        else
            g = oldcalcedition(self, context)
        end
    elseif self.edition and not next(SMODS.find_card("j_chak_collectors_edition")) then
        g = oldcalcedition(self, context)
    end
    return g
end

-- Recalc debuff when you stop dragging a card
local stop_drag_ref = Card.stop_drag
function Card:stop_drag()
  stop_drag_ref(self)
  if self.area and self.area == G.jokers then
    for k, v in pairs(G.jokers.cards) do SMODS.recalc_debuff(v) end
  end
end

-- Track and count destroyed cards
local remove_ref = Card.remove
function Card:remove()
  remove_ref(self)
  if self.getting_sliced and self.ability.set == 'Joker' then
    G.GAME.jokers_destroyed = (G.GAME.jokers_destroyed or 0) + 1 -- Last Laugh
    G.GAME.last_destroyed_joker = self.config.center.key -- False Shadow
  end
  if self.base.id ~= nil and self.base.suit ~= nil and self.base.value ~= nil then -- Steal This Joker
    G.GAME.last_destroyed_card_id = self.base.id
    G.GAME.last_destroyed_card_suit = self.base.suit
    G.GAME.last_destroyed_card_value = self.base.value
    if self.seal ~= nil then
      G.GAME.last_destroyed_card_seal = self.base.seal
    else
      G.GAME.last_destroyed_card_seal = nil
    end
    if self.edition ~= nil then
      G.GAME.last_destroyed_card_edition = self.base.edition
    else
      G.GAME.last_destroyed_card_edition = nil
    end
    if self.config.center ~= nil then
      G.GAME.last_destroyed_card_enhancement = self.config.center.key
    else
      G.GAME.last_destroyed_card_enhancement = nil
    end
  end
end

--- Thank you @bepisfever for these
-- Adds apply method to seals
local set_seal_ref = Card.set_seal
function Card:set_seal(_seal, silent, immediate)
  if self.seal then
    if G.P_SEALS[self.seal] and G.P_SEALS[self.seal].remove then
      G.P_SEALS[self.seal]:remove(self)
    end
  end
  local ret = set_seal_ref(self, _seal, silent, immediate)
  if G.P_SEALS[_seal] and G.P_SEALS[_seal].apply then
    G.P_SEALS[_seal]:apply(self)
  end
  return ret
end
-- Adds remove method to seals
local card_remove_ref = Card.remove
function Card:remove()
  local ret = card_remove_ref(self)
  if self.seal then
    if G.P_SEALS[self.seal] and G.P_SEALS[self.seal].remove then
      G.P_SEALS[self.seal]:remove(self)
    end
  end
  return ret
end