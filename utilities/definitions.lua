-- Enable optional features
SMODS.current_mod.optional_features = {
  retrigger_joker = true,
  post_trigger = true,
  quantum_enhancements = true,
}

-- Disable specific items by commenting them out
CHAK_UTIL.JOKERS = {
    "dragon_balls",
    "last_laugh",
    "unending_torment",
    "counterfeit_joker",
    "copy_cat",
    "ketheric_joker",
    "etheric_joker",
    "celestialite",
    "roffle_joker",
    "pass_go",
    "earth",
    "wind",
    "fire",
    "water",
    "earth_wind_and_fire",
    "poop_butt",
    "two-faced",
    "jimbo",
    "evoker",
    "grave_robber",
    "omicron",
    "skeeball",
    "last_prism",
    "balatrodle",
    "wishbone",
    "the_grill_master",
    "joe_joker",
    "black_lotus",
    "mox_lotus",
    "encrusted_joker",
    "derk",
    "fading_memory",
    "the_house",
    "death_and_taxes",
    "false_shadow"
}

CHAK_UTIL.CHAKRAS = {
    "root_chakra",
    "sacral_chakra",
    "solar_plexus_chakra",
    "heart_chakra",
    "throat_chakra",
    "third_eye_chakra",
    "crown_chakra",
    "red_chakra",
    "blue_chakra",
    "gold_chakra",
    "purple_chakra"
}

CHAK_UTIL.JOKER_SEALS = {
    "white",
    "red",
    "green",
    "black",
    "blue",
    "purple",
    "orange",
    "gold",
    "ethereal"
}

CHAK_UTIL.SPECTRALS = {
    "realize",
    "whole"
}

CHAK_UTIL.VOUCHERS = {
    "booster_seat",
    "drivers_seat",
    "foresight",
    "clairvoyance",
    "banishment",
    "obliteration",
    "summoning_circle"
}

CHAK_UTIL.TAGS = {
    "intangible",
    "spiritual",
    "ghostly_shopper"
}

-- Define a Booster object with certain shared properties for Chakra packs
CHAK_UTIL.ChakraBooster = SMODS.Booster:extend {
    group_key = 'chak_chakra_pack',
    kind = 'chak_chakra',
    draw_hand = false,

    loc_vars = function(self, info_queue, card)
        return {
            -- Removes the underscore with a digit at the end of a key if it exists,
            -- allowing us to make only one localization entry per type
            key = self.key:gsub('_%d$', ''),
            vars = {
                card.ability.choose,
                card.ability.extra
            }
        }
    end,

    create_card = function(self, card, i)
        return {
            set = 'ChakraConsumableType',
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true -- Allow creating Whole
        }
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.CHAK_EDITION)
        ease_background_colour { new_colour =  G.C.CHAK_EDITION, special_colour = G.C.CHAK_STICKER_ETHEREAL, contrast = 2 }
    end,

    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 4,
            speed = 0.25,
            padding = 1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.GOLD, 0.2), lighten(G.C.PURPLE, 0.2), lighten(G.C.GREEN, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}

-- Define a Joker object with certain shared properties for Token Jokers
CHAK_UTIL.TokenJoker = SMODS.Joker:extend {
    rarity = "chak_Token",
    cost = 0,
    config = {
        extra = {
            card_limit = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'chak_token_joker', set = 'Other'}
		return { vars = { card.ability.extra.card_limit } }
	end,
    add_to_deck = function(self, card, from_debuff)
      G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.card_limit
    end,
    remove_from_deck = function(self, card, from_debuff)
      G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.card_limit
    end,
}