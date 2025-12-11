SMODS.Suit {
  key = 'Bells',
  card_key = 'BELLS',

  lc_atlas = 'suits_lc',
  lc_ui_atlas = 'suits_ui_lc',
  lc_colour = G.C.CHAK_BELLS_LC,

  hc_atlas = 'suits_hc',
  hc_ui_atlas = 'suits_ui_hc',
  hc_colour = G.C.CHAK_BELLS_HC,

  pos = { y = 1 },
  ui_pos = { x = 0, y = 1 },

  in_pool = function(self, args)
    -- Allows forcing this suit to be included
    if args and args.chak and args.chak.include_bells then
      return true
    end

    if args and args.initial_deck then
      -- When creating a deck
      local back = G.GAME.selected_back
      local back_config = back and back.effect.center.chak

      local sleeve = G.GAME.selected_sleeve
      local sleeve_config = (G.P_CENTERS[sleeve] or {}).chak

      return (back_config and back_config.create_bells)
          or (sleeve_config and sleeve_config.create_bells)
    else
      -- If not creating a deck
      return CHAK_UTIL.has_suit_in_deck('chak_Bells', true) or CHAK_UTIL.spectrum_played()
    end
  end
}
