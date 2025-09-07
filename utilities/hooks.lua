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