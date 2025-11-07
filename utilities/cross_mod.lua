-- Talisman compatibility
to_big = to_big or function(n)
  return n
end

to_number = to_number or function(n)
  return n
end

-- Load modded suits
if next(SMODS.find_mod('paperback')) then
  local prefix = SMODS.find_mod('paperback')[1].prefix or "paperback"

  table.insert(CHAK_UTIL.light_suits, prefix .. '_Stars')
  table.insert(CHAK_UTIL.dark_suits, prefix .. '_Crowns')
end

if next(SMODS.find_mod('Bunco')) then
  local prefix = SMODS.find_mod('Bunco')[1].prefix or "bunc"

  table.insert(CHAK_UTIL.light_suits, prefix .. '_Fleurons')
  table.insert(CHAK_UTIL.dark_suits, prefix .. '_Halberds')
end