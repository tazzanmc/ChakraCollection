-- Create config UI
SMODS.current_mod.config_tab = function()
  return {
    n = G.UIT.ROOT,
    config = { align = 'cm', padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK },
    nodes = {
      {
        n = G.UIT.R,
        config = { align = 'cm', minh = 1 },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = localize('chak_ui_requires_restart'),
              colour = G.C.RED,
              scale = 0.5
            }
          }
        }
      },
      {
        n = G.UIT.R,
        config = { align = 'cm' },
        nodes = {
          {
            n = G.UIT.C,
            nodes = {
              create_toggle {
                label = localize('chak_ui_enable_debug'),
                ref_table = CHAK_UTIL.config,
                ref_value = 'debug_enabled'
              }
            }
          }
        }
      },--[[
      {
        n = G.UIT.R,
        config = { align = 'cm', minh = 1 },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = localize('chak_ui_no_requires_restart'),
              colour = G.C.GREEN,
              scale = 0.5
            }
          }
        }
      }]]
    }
  }
end

-- Create Credits tab in our mod UI
SMODS.current_mod.extra_tabs = function()
  local result = {}

  for k, v in pairs(CHAK_UTIL.credits) do
    local parsed = {}

    for _, entry in ipairs(v.entries) do
      parsed[#parsed + 1] = {
        n = G.UIT.R,
        config = { align = 'cm', minh = 0.25 },
        nodes = {
          { n = G.UIT.T, config = { text = entry, colour = v.color, scale = 0.4 } }
        }
      }
    end

    result[k] = parsed
  end

  local credits_tab = {
    n = G.UIT.ROOT,
    config = { align = 'cm', padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK },
    nodes = {
      {
        n = G.UIT.R,
        config = { align = 'cm', minh = 1 },
        nodes = {
          {
            n = G.UIT.C,
            config = { padding = 0.5 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = 'cm' },
                nodes = {
                  { n = G.UIT.T, config = { text = localize('chak_ui_me'), colour = G.C.CHIPS, scale = 0.75 } },
                }
              },
              unpack(result.me)
            }
          }
        }
      },
      {
        n = G.UIT.R,
        nodes = {
          {
            n = G.UIT.C,
            config = { padding = 0.5 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = 'cm' },
                nodes = {
                  { n = G.UIT.T, config = { text = localize('chak_ui_wikis'), colour = G.C.CHIPS, scale = 0.75 } },
                }
              },
              unpack(result.wikis)
            }
          },
          {
            n = G.UIT.C,
            config = { padding = 0.5 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = 'cm' },
                nodes = {
                  { n = G.UIT.T, config = { text = localize('chak_ui_discord'), colour = G.C.CHIPS, scale = 0.75 } },
                }
              },
              unpack(result.discord)
            }
          },
          {
            n = G.UIT.C,
            config = { padding = 0.5 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = 'cm' },
                nodes = {
                  { n = G.UIT.T, config = { text = localize('chak_ui_mods'), colour = G.C.CHIPS, scale = 0.75 } }
                }
              },
              unpack(result.mods)
            }
          }
        }
      }
    }
  }

  return {
    {
      label = localize('b_credits'),
      tab_definition_function = function()
        return credits_tab
      end
    }
  }
end

function CHAK_UTIL.collection_UIBox(_pool, rows, args)
  args = args or {}
  args.w_mod = args.w_mod or 1
  args.h_mod = args.h_mod or 1
  args.card_scale = args.card_scale or 1
  local deck_tables = {}
  local pool = SMODS.collection_pool(_pool)

  G.your_collection = {}
  local cards_per_page = 0
  local row_totals = {}
  for j = 1, #rows do
    if cards_per_page >= #pool and args.collapse_single_page then
      rows[j] = nil
    else
      row_totals[j] = cards_per_page
      cards_per_page = cards_per_page + rows[j]
      G.your_collection[j] = CardArea(
        G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
        (args.w_mod * rows[j] + 0.25) * G.CARD_W,
        args.h_mod * G.CARD_H,
        { card_limit = rows[j], type = args.area_type or 'title', highlight_limit = 0, collection = true }
      )
      table.insert(deck_tables,
        {
          n = G.UIT.R,
          config = { align = "cm", padding = 0.07, no_fill = true },
          nodes = {
            { n = G.UIT.O, config = { object = G.your_collection[j] } }
          }
        })
    end
  end

  local options = {}
  for i = 1, math.ceil(#pool / cards_per_page) do
    table.insert(
      options,
      localize('k_page') .. ' ' .. tostring(i) .. '/' .. tostring(math.ceil(#pool / cards_per_page))
    )
  end

  G.FUNCS.chak_card_collection_page = function(e)
    if not e or not e.cycle_config then return end
    for j = 1, #G.your_collection do
      for i = #G.your_collection[j].cards, 1, -1 do
        local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
        c:remove()
        c = nil
      end
    end
    for j = 1, #rows do
      for i = 1, rows[j] do
        local center = pool[i + row_totals[j] + (cards_per_page * (e.cycle_config.current_option - 1))]
        if not center then break end
        local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
          G.CARD_W * args.card_scale, G.CARD_H * args.card_scale, G.P_CARDS.empty,
          (args.center and G.P_CENTERS[args.center]) or center)
        if args.modify_card then args.modify_card(card, center, i, j) end
        if not args.no_materialize then card:start_materialize(nil, i > 1 or j > 1) end
        G.your_collection[j]:emplace(card)
      end
    end
    INIT_COLLECTION_CARD_ALERTS()
  end

  G.FUNCS.chak_card_collection_page { cycle_config = { current_option = 1 } }

  local t = create_UIBox_generic_options({
    back_func = (args and args.back_func) or G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or 'your_collection',
    snap_back = args.snap_back,
    infotip = args.infotip,
    no_back = true,
    contents = {
      { n = G.UIT.R, config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = deck_tables },
      (not args.hide_single_page or cards_per_page < #pool) and {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = {
          create_option_cycle({
            options = options,
            w = 4.5,
            cycle_shoulders = true,
            opt_callback = 'chak_card_collection_page',
            current_option = 1,
            colour = G.C.RED,
            no_pips = true,
            focus_args = { snap_to = true, nav = 'wide' }
          })
        }
      } or nil,
    }
  })
  return t
end

G.FUNCS.chak_select_joker = function(e)
  local c1 = e.config.ref_table

  if c1 and c1.is and type(c1.is) == "function" and c1:is(Card) then
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.1,
      func = function()
        G.SETTINGS.paused = false
        if G.OVERLAY_MENU ~= nil then
          G.OVERLAY_MENU:remove()
          G.OVERLAY_MENU = nil
        end

        SMODS.add_card {
          key = c1.config.center_key,
          area = e.config.data[1]
        }

        return true
      end
    }))
  end
end

function CHAK_UTIL.create_select_card_ui(card, area)
  local t2 = {
    n = G.UIT.ROOT,
    config = {
      ref_table = card,
      minw = 0.6,
      padding = 0.1,
      align = 'bm',
      colour = G.C.GREEN,
      shadow = true,
      r = 0.08,
      minh = 0.3,
      one_press = true,
      button = 'chak_select_joker',
      data = { area },
      hover = true
    },
    nodes = {
      {
        n = G.UIT.T,
        config = {
          text = 'Select',
          colour = G.C.WHITE,
          scale = 0.42
        }
      }
    }
  }

  card.children.select_button = UIBox {
    definition = t2,
    config = {
      align = "bm",
      offset = { x = -0, y = -0.15 },
      major = card,
      bond = 'Weak',
      parent = card
    }
  }
end

--- Recreation of Paperback light suit & dark suit code
-- Returns a table that can be inserted into info_queue to show all suits of the provided type
--- @param type 'light' | 'dark'
--- @return table
function CHAK_UTIL.suit_tooltip(type)
  local suits = type == 'light' and CHAK_UTIL.light_suits or CHAK_UTIL.dark_suits

  local key = 'chak_' .. type .. '_suits'
  local colours = {}

  -- If any modded suits were loaded, we need to dynamically
  -- add them to the localization table
  if #suits > 2 then
    local text = {}
    local line = ""
    local text_parsed = {}

    for i = 1, #suits do
      local suit = suits[i]

      -- Remove Bunco exotic suits if they are not revealed yet
      if next(SMODS.find_mod("Bunco")) and not (G.GAME and G.GAME.Exotic) then
        if suit == "bunc_Fleurons" or suit == "bunc_Halberds" then
          suit = nil
        end
      end

      if suit ~= nil then
        colours[#colours + 1] = G.C.SUITS[suit] or G.C.IMPORTANT
        line = line .. "{V:" .. i .. "}" .. localize(suit, 'suits_plural') .. "{}"

        if i < #suits then
          line = line .. ", "
        end

        if #line > 30 then
          text[#text + 1] = line
          line = ""
        end
      end
    end

    if #line > 0 then
      text[#text + 1] = line
    end

    for _, v in ipairs(text) do
      text_parsed[#text_parsed + 1] = loc_parse_string(v)
    end

    G.localization.descriptions.Other[key].text = text
    G.localization.descriptions.Other[key].text_parsed = text_parsed
  end

  return {
    set = 'Other',
    key = key,
    vars = {
      colours = colours
    }
  }
end