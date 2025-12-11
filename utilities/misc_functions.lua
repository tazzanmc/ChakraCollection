---- Thank you Paperback mod for most these functions

--- Registers a list of items in a custom order
--- @param items table
--- @param path string
function CHAK_UTIL.register_items(items, path)
  for i = 1, #items do
    SMODS.load_file(path .. "/" .. items[i] .. ".lua")()
  end
end

--- Return the length of a table
--- @param t table
--- @return int
function CHAK_UTIL.table_length(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

--- @param t table
--- @param v any
--- @return boolean
function CHAK_UTIL.table_contains(t,v)
  for i = 1, #t do
    if t[i] == v then
      return true
    end
  end
  return false
end

--- Check if input is a number
--- @param x any
--- @return boolean
function CHAK_UTIL.is_number(x)
  if tonumber(x) ~= nil then
    return true
  end
  return false
end

--- Whether a given value is of the Card type
--- @param c any
--- @return boolean
function CHAK_UTIL.is_card(c)
  return c and type(c) == "table" and c.is and type(c.is) == "function" and c:is(Card)
end

--- Returns hands or discards, whichever is lower
--- @return { hands: boolean?, discards: boolean?, amt: integer }
function CHAK_UTIL.get_lowest_hand_discard()
  if not G.GAME then return { amt = 0 } end

  local hands = G.GAME.current_round.hands_left
  local discards = G.GAME.current_round.discards_left

  if hands == discards then
    return { amt = hands, discards = true, hands = true }
  elseif hands < discards then
    return { amt = hands, hands = true }
  else
    return { amt = discards, discards = true }
  end
end

---This function is basically a copy of how the base game does the flipping animation
---on playing cards when using a consumable that modifies them
---@param card table?
---@param cards_to_flip table?
---@param action function?
---@param sound string?
function CHAK_UTIL.use_consumable_animation(card, cards_to_flip, action, sound)
  -- If it's not a list, make it one
  if cards_to_flip and not cards_to_flip[1] then
    cards_to_flip = { cards_to_flip }
  end

  if card then
    G.E_MANAGER:add_event(Event {
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound(sound or 'tarot1')
        card:juice_up(0.3, 0.5)
        return true
      end
    })
  end

  if cards_to_flip then
    for i = 1, #cards_to_flip do
      local c = cards_to_flip[i]
      local percent = 1.15 - (i - 0.999) / (#cards_to_flip - 0.998) * 0.3

      G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.15,
        func = function()
          c:flip()
          play_sound('card1', percent)
          c:juice_up(0.3, 0.3)
          return true
        end
      })
    end

    delay(0.2)
  end

  G.E_MANAGER:add_event(Event {
    trigger = 'after',
    delay = 0.1,
    func = function()
      if action and type(action) == "function" then
        action()
      end
      return true
    end
  })

  if cards_to_flip then
    for i = 1, #cards_to_flip do
      local c = cards_to_flip[i]
      local percent = 0.85 + (i - 0.999) / (#cards_to_flip - 0.998) * 0.3

      G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.15,
        func = function()
          c:flip()
          play_sound('tarot2', percent, 0.6)
          c:juice_up(0.3, 0.3)

          -- Update the sprites of cards
          if c.config and c.config.center then
            c:set_sprites(c.config.center)
          end
          if c.ability then
            c.front_hidden = c:should_hide_front()
          end

          return true
        end
      })
    end
  end

  G.E_MANAGER:add_event(Event {
    trigger = 'after',
    delay = 0.2,
    func = function()
      G.hand:unhighlight_all()
      return true
    end
  })

  G.E_MANAGER:add_event(Event{
    trigger = 'after',
    delay = 0.2,
    func = function()
      G.jokers:unhighlight_all()
      return true
    end
  })

  if cards_to_flip then
    delay(0.5)
  end
end

--- Shows the "Nope!" text that Wheel of Fortune does when failing on top of a card
--- @param card table
--- @param color table? the color of the square that pops up, defaults to Tarot
function CHAK_UTIL.show_nope_text(card, color)
  -- This is all a copy of how the base game does it
  G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = 0.4,
    func = function()
      local booster = G.STATE == G.STATES.TAROT_PACK
          or G.STATE == G.STATES.SPECTRAL_PACK
          or G.STATE == G.STATES.SMODS_BOOSTER_OPENED

      attention_text({
        text = localize('k_nope_ex'),
        scale = 1.3,
        hold = 1.4,
        major = card,
        backdrop_colour = color or G.C.SECONDARY_SET.Tarot,
        align = booster and 'tm' or 'cm',
        offset = {
          x = 0,
          y = booster and -0.2 or 0
        },
        silent = true
      })

      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.06 * G.SETTINGS.GAMESPEED,
        blockable = false,
        blocking = false,
        func = function()
          play_sound('tarot2', 0.76, 0.4)
          return true
        end
      }))

      play_sound('tarot2', 1, 0.4)
      card:juice_up(0.3, 0.5)
      return true
    end
  }))
end

--- Creates and opens the specified booster pack
--- @param pack_key string
function CHAK_UTIL.open_booster_pack(pack_key)
  local booster = SMODS.create_card { key = pack_key, area = G.play }
  booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
  booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
  booster.T.w = G.CARD_W * 1.27
  booster.T.h = G.CARD_H * 1.27

  booster.cost = 0
  booster.from_tag = false

  booster:start_materialize()
  booster:open()
  return true
end

--- Creates and opens the specified booster pack, the same way a Tag would do it
--- @param pack_key string
function CHAK_UTIL.open_booster_pack_from_tag(pack_key)
  local booster = SMODS.create_card { key = pack_key, area = G.play }
  booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
  booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
  booster.T.w = G.CARD_W * 1.27
  booster.T.h = G.CARD_H * 1.27

  booster.cost = 0
  booster.from_tag = true

  G.FUNCS.use_card { config = { ref_table = booster } }
  booster:start_materialize()
  return true
end

--- Adds a tag the same way vanilla does it
--- @param tag string | table a tag key or a tag table
--- @param event boolean? whether to send this in an event or not
--- @param silent boolean? whether to play a sound
function CHAK_UTIL.add_tag(tag, event, silent)
  local func = function()
    add_tag(type(tag) == 'string' and Tag(tag) or tag)
    if not silent then
      play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
      play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
    end
    return true
  end

  if event then
    G.E_MANAGER:add_event(Event {
      func = func
    })
  else
    func()
  end
end

--- Credit to Aikoyori for this function, and RenSnek for expanding it. Given a `table_in` (value table or card object) and a config table, modifies the values in `table_in` depending 
--- on the `config` provided. `config` accepts these values:
--- * `add`
--- * `multiply`
--- * `keywords`: list of specific values to change in `table_in`. If nil, change every value in `table_in`.
--- * `unkeywords`: list of specific values to *not* change in `table_in`.
--- * `x_protect`: if true (or not set), any X effects (Xmult, Xchips, etc.) whose value is currently 1 are not modified. If false, this check is bypassed - which may result in some unlisted values being 
--- modified.
--- * `reference`: initial values for the provided table. If nil, defaults to `table_in`.
--- 
--- This function scans all sub-tables for numeric values, so it's recommended to pass the card's ability table rather than the entire card object.
---@param table_in table|Card
---@param config table
function CHAK_UTIL.mod_card_values(table_in, config)
  if not config then config = {} end
  local add = config.add or 0
  local multiply = config.multiply or 1
  local keywords = config.keywords or {}
  local unkeyword = config.unkeywords or {}
  local x_protect = config.x_protect or true -- If true and a key is "Xmult" and the value is 1, it won't multiply (apart from Xmult_gain)
  local reference = config.reference or table_in
  local function modify_values(table_in, ref)
    for k,v in pairs(table_in) do -- For key, value in the table
      if type(v) == "number" then -- If it's a number
        if (keywords[k] or (CHAK_UTIL.REND.table_true_size(keywords) < 1)) and not unkeyword[k] then -- If it's in the keywords, OR there's no keywords and it isn't in the unkeywords
          if ref and ref[k] then -- If it exists in the reference
            if not (x_protect and (k == "Xmult" or k == "x_mult" or CHAK_UTIL.REND.starts_with(k,"h_x_")) and ref[k] == 1) then
              table_in[k] = (ref[k] + add) * multiply -- Set it to (reference's value + add) * multiply
            end
          end
        end
      elseif type(v) == "table" then -- If it's a table
        modify_values(v, ref[k]) -- Recurse for values in the table
      end
    end
  end
  if table_in == nil then
    return
  end
  modify_values(table_in, reference)
end

-- couple util funcs nabbed from https://github.com/RenSnek/Balatro-Rendoms :33 (nested into CHAK_UTIL to avoid compatibility issues)
CHAK_UTIL.REND = {}

--- Credit to RenSnek. Given a string `str` and a shorter string `start`, checks if the string's first `#start` characters are the same as `start`.
---@param str string
---@param start string
---@return boolean
CHAK_UTIL.REND.starts_with = function(str,start)
    return str:sub(1, #start) == start
end

--- Credit to RenSnek. Given a `table` and a `value`, returns true if `value` is found in `table`.
---@param table table
---@param value any
---@return boolean
CHAK_UTIL.REND.table_contains = function(table,value)
    for i = 1,#table do
        if (table[i] == value) then
            return true
        end
    end
    return false
end

--- Credit to RenSnek. Given a table, returns a more accurate estimate of its size than the `#` operator.
---@param table table
---@return number
CHAK_UTIL.REND.table_true_size = function(table)
    local n = 0
    for k,v in pairs(table) do
        n = n+1
    end
    return n
end

---Credit to Paperback. Used to check whether a card is a light or dark suit
---@param card table
---@param type 'light' | 'dark'
---@return boolean
function CHAK_UTIL.is_suit(card, type)
  for _, v in ipairs(type == 'light' and CHAK_UTIL.light_suits or CHAK_UTIL.dark_suits) do
    if card:is_suit(v) then return true end
  end
  return false
end

---Credit to Paperback. Checks if the provided suit is currently in the deck
---@param suit string
---@param ignore_wild? boolean
---@return boolean
function CHAK_UTIL.has_suit_in_deck(suit, ignore_wild)
  for _, v in ipairs(G.playing_cards or {}) do
    if not SMODS.has_no_suit(v) and (v.base.suit == suit or (not ignore_wild and v:is_suit(suit))) then
      return true
    end
  end
  return false
end

---Credit to Paperback. Checks if a spectrum hand has been played
--- @return boolean
function CHAK_UTIL.spectrum_played()
  local spectrum_played = false
  if G and G.GAME and G.GAME.hands then
    for k, v in pairs(G.GAME.hands) do
      if string.find(k, "Spectrum", nil, true) then
        if G.GAME.hands[k].played > 0 then
          spectrum_played = true
          break
        end
      end
    end
  end

  return spectrum_played
end

---Credit to Multiplayer Balatro!
---Func to draw a card from play to your deck
CHAK_UTIL.draw_from_play_to_deck = function()
  local play_count = #G.play.cards
  local it = 1
  for k, v in ipairs(G.play.cards) do
    if (not v.shattered) and (not v.destroyed) then 
      draw_card(G.play, G.deck, it*100/play_count, 'down', false, v)
      it = it + 1
    end
  end
end