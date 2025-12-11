-- LOAD --
CHAK_UTIL = {}

-- Main menu
SMODS.load_file("main_menu.lua")

-- Loads functions into CHAK_UTIL
SMODS.load_file("utilities/definitions.lua")()
SMODS.load_file("utilities/hooks.lua")()
SMODS.load_file("utilities/misc_functions.lua")()
SMODS.load_file("utilities/ui.lua")()
SMODS.load_file("utilities/cross_mod.lua")()

-- Load Atlases
SMODS.load_file("content/atlases.lua")()

-- Load Jokers
CHAK_UTIL.register_items(CHAK_UTIL.JOKERS, "content/jokers")

-- Load Chakras
CHAK_UTIL.register_items(CHAK_UTIL.CHAKRAS, "content/chakras")

-- Load Spectrals
CHAK_UTIL.register_items(CHAK_UTIL.SPECTRALS, "content/spectrals")

-- Load Tarots
CHAK_UTIL.register_items(CHAK_UTIL.TAROTS, "content/tarots")

-- Load Boosters
CHAK_UTIL.register_items(CHAK_UTIL.BOOSTERS, "content/boosters")

-- Load Enhancements
CHAK_UTIL.register_items(CHAK_UTIL.ENHANCEMENTS, "content/enhancements")

-- Load Seals
CHAK_UTIL.register_items(CHAK_UTIL.SEALS, "content/seals")

-- Load Joker Seals
CHAK_UTIL.register_items(CHAK_UTIL.JOKER_SEALS, "content/joker_seals")

-- Load Vouchers
CHAK_UTIL.register_items(CHAK_UTIL.VOUCHERS, "content/vouchers")

-- Load Tags
CHAK_UTIL.register_items(CHAK_UTIL.TAGS, "content/tags")

-- Load Stickers
CHAK_UTIL.register_items(CHAK_UTIL.STICKERS, "content/stickers")

-- Load Decks
CHAK_UTIL.register_items(CHAK_UTIL.DECKS, "content/decks")

-- Load Debug if it's enabled
if CHAK_UTIL.config.debug_enabled then
    CHAK_UTIL.register_items(CHAK_UTIL.DEBUG, "content/debug")
end

-- Load Bells & Acorns if enabled
CHAK_UTIL.register_items(CHAK_UTIL.SUITS, "content/suits")

if CHAK_UTIL.config.include_bells then
    table.insert(CHAK_UTIL.light_suits, 'chak_Bells')
end
if CHAK_UTIL.config.include_acorns then
    table.insert(CHAK_UTIL.dark_suits, 'chak_Acorns')
end

-- CONSUMABLES --
SMODS.ConsumableType {                    -- Chakra Cards
    key = 'ChakraConsumableType',
    collection_rows = { 3, 4 },           --amount of cards in one page
    primary_colour = G.C.CHAK_EDITION,    --first color
    secondary_colour = G.C.CHAK_EDITION,  --second color
    loc_txt = {
        collection = 'Chakra Cards',      --name displayed in collection
        name = 'Chakra',                  --name displayed in badge
        undiscovered = {
            name = 'Hidden Chakra',       --undiscovered name
            text = { 'Chakra undisovered' } --undiscovered text
        }
    },
    shop_rate = 0, --rate in shop out of 100
    default = 'c_chak_root_chakra',
    draw
}

SMODS.UndiscoveredSprite {
    key = 'ChakraConsumableType', --must be the same key as the consumabletype
    atlas = 'Chakras',
    pos = { x = 0, y = 3 }
}

-- SHADERS --
SMODS.Shader {
    key = 'ignited',
    path = 'ignited.fs'
}

-- EDITIONS --
SMODS.Edition { -- Retrigger itself, chance to destroy
    key = 'ignited',
    shader = 'ignited',
    loc_txt = {
        name = 'Ignited', --name of card
        label = 'Ignited',
        text = {          --text of card
            '{C:attention}Retriggers{} itself, {C:green}#1# in #2#',
            'chance this card is {C:red}destroyed',
            '{C:inactive,s:0.8}Jokers are destroyed at end of round'
        }
    },
    in_shop = true,
    extra_cost = 4,
    weight = 3,
    sound = {
        sound = "explosion_release1", per = 1.2, vol = 0.4
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    config = {
        odds = 2,
        destroyed = 1
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.edition.odds, 'chak_ignited')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.other_card == card
            and (
                (context.repetition and context.cardarea == G.play)
                or (context.retrigger_joker_check and not context.retrigger_joker)
            )
        then
            return {
                message = 'Again!',
                repetitions = 1,
                card = card,
            }
        end
        if context.destroying_card and context.destroy_card == card then
            if SMODS.pseudorandom_probability(card, 'chak_ignited', 1, card.edition.odds) then
                return {
                    card = card,
                    message = 'Extinguished!',
                    SMODS.destroy_cards(card),
                    sound = 'crumple1',
                    volume = 0.7,
                    pitch = 1.2,
                    remove = true
                }
            end
        elseif context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'chak_ignited', 1, card.edition.odds) then
                return {
                    card = card,
                    message = 'Extinguished!',
                    SMODS.destroy_cards(card),
                    sound = 'crumple1',
                    volume = 0.7,
                    pitch = 1.2,
                    remove = true
                }
            end
        end
    end
}

-- When calculating the sell cost for a card, if it is Ethereal then override it
-- and set the sell cost to 0
local set_cost_ref = Card.set_cost
function Card.set_cost(self)
    local ret = set_cost_ref(self)
    if self.added_to_deck then
        -- If this card is Ethereal set sell cost to 0
        if self.ability.chak_ethereal then
            self.sell_cost = 0
        end
    end
    return ret
end

-- STAKES --
SMODS.Stake {
    name = "Ethereal Stake",
    key = "ethereal_stake",
    prefix_config = { applied_stakes = { mod = false } },
    applied_stakes = { "gold" },
    sticker_atlas = "Stickers",
    sticker_pos = { x = 0, y = 0 },
    atlas = "Chips",
    pos = { x = 0, y = 0 },
    modifiers = function()
        G.GAME.modifiers.enable_ethereal_in_shop = true
    end,
    colour = G.C.CHAK_STICKER_ETHEREAL,
    shiny = true
}

-- RARITIES --
SMODS.Rarity {
    key = 'Token',
    default_weight = 0.0,
    badge_colour = HEX('B5B4B1'),
    get_weight = function(self, weight, object_type)
        return weight
    end
}

-- DRAW STEPS --
SMODS.DrawStep {
    key = 'chak_chakras',
    order = 10,
    func = function(self)
        if (self.ability.set == 'ChakraConsumableType') and self:should_draw_base_shader() then
            self.children.center:draw_shader('negative_shine', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}
--[[ Booster shader for draft deck (currently bugged)
SMODS.DrawStep {
    key = 'chak_decks',
    order = 10,
    func = function(self)
        if G.GAME.selected_back.effect.center.key == 'b_chak_draft' then
            if self.area == G.deck or self.area == nil then
                local send_to_shader = { math.min(self.children.back.VT.r * 3, 1) + G.TIMERS.REAL / (28) +
                (self.juice and self.juice.r * 20 or 0), self.ARGS.send_to_shader[2] }
                self.children.back:draw_shader('booster', nil, send_to_shader, true, nil, nil, nil, nil, nil, nil, false)
            else
                local send_to_shader = { math.min(self.children.back.VT.r * 3, 1) + G.TIMERS.REAL / (28) +
                (self.juice and self.juice.r * 20 or 0) + self.tilt_var.amt, self.ARGS.send_to_shader[2] }
                self.children.back:draw_shader('booster', nil, send_to_shader)
            end
        end
    end,
    conditions = { vortex = false, facing = 'back' },
}
]]
SMODS.DrawStep {
    key = 'chak_jokers',
    order = 10,
    func = function(self)
        if (self.config.center.key == 'j_chak_unending_torment' and (self.config.center.discovered or self.bypass_discovery_center)) and self:should_draw_base_shader() then
            self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
        end
        if (self.config.center.key == 'j_chak_etheric_joker' and (self.config.center.discovered or self.bypass_discovery_center)) and self:should_draw_base_shader() then
            self.children.center:draw_shader('negative_shine', nil, self.ARGS.send_to_shader)
        end
        --[[
        if (self.config.center.key == 'j_chak_seeing_double' and (self.config.center.discovered or self.bypass_discovery_center)) and self:should_draw_base_shader() then
            self.children.center:draw_shader('chak_seeing_double', nil, self.ARGS.send_to_shader)
        end]]
    end,
    conditions = { vortex = false, facing = 'front' },
}

-- JOKER DISPLAY --
if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end
