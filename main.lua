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

-- BOOSTERS --
CHAK_UTIL.ChakraBooster {       -- Chakra Pack
    key = 'chakra_pack_normal', --key
    atlas = 'Boosters',         --atlas
    pos = { x = 0, y = 0 },     --position in atlas
    loc_txt = {                 -- local text
        name = 'Chakra Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_edition}Chakra{} cards to',
            'be used immediately'
        }
    },
    cost = 4,
    weight = 1,
    config = {
        extra = 2,
        choose = 1
    }
}

CHAK_UTIL.ChakraBooster {      -- Jumbo Chakra Pack
    key = 'chakra_pack_jumbo', --key
    atlas = 'Boosters',        --atlas
    pos = { x = 1, y = 0 },    --position in atlas
    loc_txt = {                -- local text
        name = 'Jumbo Chakra Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_edition}Chakra{} cards to',
            'be used immediately'
        }
    },
    cost = 6,
    weight = 1,
    config = {
        extra = 4,
        choose = 1
    }
}

CHAK_UTIL.ChakraBooster {     -- Mega Chakra Pack
    key = 'chakra_pack_mega', --key
    atlas = 'Boosters',       --atlas
    pos = { x = 2, y = 0 },   --position in atlas
    loc_txt = {               -- local text
        name = 'Mega Chakra Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_edition}Chakra{} cards to',
            'be used immediately'
        }
    },
    cost = 8,
    weight = 0.25,
    config = {
        extra = 4,
        choose = 2
    }
}

CHAK_UTIL.ChakraBooster {       -- Single Chakra Pack
    key = 'chakra_pack_single', --key
    atlas = 'Boosters',         --atlas
    pos = { x = 3, y = 0 },     --position in atlas
    loc_txt = {                 -- local text
        name = 'Single Chakra Pack',
        text = {
            'Choose {C:attention}#1#{}',
            '{C:chak_edition}Chakra{} card to',
            'be used immediately'
        }
    },
    cost = 2,
    weight = 0,
    config = {
        extra = 1,
        choose = 1
    }
}

SMODS.Booster {
    key = "buffoon_ethereal",
    weight = 0.3,
    kind = 'Buffoon',   -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 1,
    atlas = 'Boosters', --atlas
    pos = { x = 0, y = 1 },
    loc_txt = {         -- local text
        name = 'Ethereal Buffoon Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:chak_sticker_ethereal,E:2}Ethereal{} Joker cards'
        }
    },
    config = { extra = 6, choose = 1 },
    group_key = "k_buffoon_pack",
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            --key = self.key:sub(1, -3), -- This uses the description key of the booster without the number at the end
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
    create_card = function(self, card, i)
        ret = SMODS.create_card {
            set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf"
        }
        ret:add_sticker('chak_ethereal', true)
        return ret
    end,
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
        odds = 3,
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
