-- Mod icon
SMODS.Atlas({
    key = 'modicon',
    path = 'chaldur_icon.png',
    px = 32,
    py = 32
})

-- Mod setup definitions
Chaldur = SMODS.current_mod
Chaldur.config = SMODS.current_mod.config

SMODS.load_file("src/config_tab.lua")()

-- Mod variable definitions
Chaldur.pages_to_add = {}   -- "Queue" of pages to add to Chaldur screen
Chaldur.challenge_setup = { -- Variables to track related to setting up/showing/operating the Chaldur screen
    choices = {
        challenge = nil,
        stake = nil,
        seed = nil,
        seed_temp = ''
    },
    challenge_select_areas = {},
    current_page = 1, -- The currently active challenge selection page
    pages = {},       -- All available challenge selection pages
}
Chaldur.hover_index = 0
G.E_MANAGER.queues.chaldur = {} -- The Chaldur event queue

-- Testing variable definitions
Chaldur.test_mode = true -- Enable or disable testing features for Chaldur development


-- ### Function hooks ###


-- ### Challenge select functions ###
local spacing = 0.25

-- Create a new UI definition for the Chaldur overlay.
function G.UIDEF.challenge_setup_option(from_game_over)
    local chaldur_screen = {
        n = G.UIT.ROOT,
        config = {align = "cm", colour = G.C.CLEAR},
        nodes = {
            {n = G.UIT.C,
            config = {align = "cr"},
            nodes = {
                {n = G.UIT.R, -- ROW 1: Challenge Select and Challenge Preview
                config = {align = "cr"},
                nodes = {
                    generate_challenge_select_ui(),
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, colour = G.C.GREY},
                    nodes = {
                        {n = G.UIT.T, config = {text = "Challenge Preview", colour = G.C.WHITE, scale = 0.4}}
                    }},
                }},
                {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                {n = G.UIT.R, -- ROW 2: Challenge Page Switcher, Random Challenge, Last Challenge
                config = {align = "cr"},
                nodes = {
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, colour = G.C.VOUCHER}, nodes = {
                        {n = G.UIT.T, config = {text = "< Challenge Select Page Switcher >", colour = G.C.WHITE, scale = 0.4}},
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.CHANCE}, nodes = {
                        {n = G.UIT.T, config = {text = "Random Challenge", colour = G.C.WHITE, scale = 0.4}}
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.CHIPS}, nodes = {
                        {n = G.UIT.T, config = {text = "Last Challenge", colour = G.C.WHITE, scale = 0.4}}
                    }}
                }},
                {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                {n = G.UIT.R, -- ROW 3: Stake Select and Switcher, Last Stake
                config = {align = "cr"},
                nodes = {
                    {n = G.UIT.C, config = {colour = G.C.ETERNAL}, nodes = {}},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minh = 1, colour = G.C.BLUE}, nodes = {
                        {n = G.UIT.T, config = {text = "< Stake Select >", colour = G.C.WHITE, scale = 0.4}}
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.BOOSTER}, nodes = {
                            {n = G.UIT.T, config = {text = "Last Stake", colour = G.C.WHITE, scale = 0.4}}
                    }}
                }},
                {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                {n = G.UIT.R, -- ROW 4: Seed Input, Play
                config = {align = "cr"},
                nodes = {
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 8, minh = 1, colour = G.C.FILTER}, nodes = {
                        {n = G.UIT.T, config = {text = "Seed Input", colour = G.C.WHITE, scale = 0.4}}
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.ETERNAL}, nodes = {
                        {n = G.UIT.T, config = {text = "Play", colour = G.C.WHITE, scale = 0.4}}
                    }}
                }}
            }}
        }
    }

    return chaldur_screen
end

-- Create the Chaldur screen challenge selection grid
function generate_challenge_select_ui()
    local challenge_grid = {n = G.UIT.C, config = {align = "cm", r = 0.1, padding = spacing, colour = G.C.BLACK}, nodes = {}}
    local count = 1
    for i = 1, 2 do
        local challenge_row = {n = G.UIT.R, nodes = {}}

        for j = 1, 6 do
            if count > #G.CHALLENGES then return end
            local challenge_slot_card_area = CardArea(G.ROOM.T.w, G.ROOM.T.h, G.CARD_W, G.CARD_H, {type = 'deck'})
            local challenge_slot = {
                n = G.UIT.C, nodes = {
                    {n = G.UIT.O, config = {object = challenge_slot_card_area}, id = "challenge_"..count}
                }
            }
            table.insert(challenge_row.nodes, challenge_slot)
            local challenge_card = Card(challenge_slot_card_area.T.x, challenge_slot_card_area.T.y, G.CARD_W, G.CARD_H, G.P_CENTERS.b_challenge, G.P_CENTERS.b_challenge)
            challenge_card.sprite_facing = 'back'
            challenge_card.facing = 'back'
            challenge_card.children.back = Sprite(challenge_card.T.x, challenge_card.T.y, challenge_card.T.w, challenge_card.T.h, G.ASSET_ATLAS[G.P_CENTERS.b_challenge.unlocked and G.P_CENTERS.b_challenge.atlas or 'centers'], G.P_CENTERS.b_challenge.unlocked and G.P_CENTERS.b_challenge.pos or {x = 4, y = 0})
            challenge_card.children.back.states.collide.can = false
            challenge_card.children.back:set_role({major = challenge_card, role_type = 'Glued', draw_major = challenge_card})
            challenge_slot_card_area:emplace(challenge_card)
            count = count + 1
        end
        table.insert(challenge_grid.nodes, challenge_row)
    end

    return challenge_grid
end