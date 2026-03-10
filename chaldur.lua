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

-- Create a new UI definition for the Chaldur overlay.
function G.UIDEF.challenge_setup_option(from_game_over)
    -- initial logs for helpful things
    sendInfoMessage(tostring("There are "..#G.CHALLENGES.." challenges"), "ChaldurLogger")

    -- Generate the Chaldur UI
    local chaldur_screen = {
        n = G.UIT.ROOT,
        config = {align = "cm", r = 0.1, padding = 0.2, colour = G.C.BLACK},
        nodes = {
            {n = G.UIT.C,
            nodes = {
                {n = G.UIT.R,
                config = {align = "cm", padding = 0.2, colour = G.C.RED},
                nodes ={
                    {n = G.UIT.T, config = {text = "Chaldur Screen", colour = G.C.WHITE, scale = 0.5}},
                }},
                {n = G.UIT.R,
                config = {align = "cl", padding = 0.2, colour = G.C.PALE_GREEN},
                nodes = {
                    {n = G.UIT.C,
                    config = {align = "tm"},
                    nodes = {
                        {n = G.UIT.R, nodes = {
                            generate_challenge_select_ui(),
                        }},
                        {n = G.UIT.R, config = {align = "cm", minh = 0.2}, nodes = {
                            {n = G.UIT.T, config = {text = "Spacer", colour = G.C.WHITE, scale = 0.4}},
                        }},
                        {n = G.UIT.R, config = {align = "cm", r = 0.1, minw = 8, minh = 1, colour = G.C.VOUCHER}, nodes = {
                            {n = G.UIT.T, config = {text = "< Challenge Select Page Switcher >", colour = G.C.WHITE, scale = 0.4}},
                        }}
                    }},
                    {n = G.UIT.C, config = {align = "cm", minw = 0.2}, nodes = {
                        {n = G.UIT.T, config = {text = "Spacer", colour = G.C.WHITE, scale = 0.4}},
                    }},
                    {n = G.UIT.C,
                    config = {align = "cm"},
                    nodes = {
                        {n = G.UIT.R, config = {align = "cm", r = 0.1, minw = 4, minh = 4, colour = G.C.GREY}, nodes = {
                            {n = G.UIT.T, config = {text = "Challenge Preview", colour = G.C.WHITE, scale = 0.4}},
                        }},
                        {n = G.UIT.R, config = {align = "cm", minh = 0.2}, nodes = {
                            {n = G.UIT.T, config = {text = "Spacer", colour = G.C.WHITE, scale = 0.4}},
                        }},
                        {n = G.UIT.R, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.CHANCE}, nodes = {
                            {n = G.UIT.T, config = {text = "Random Challenge", colour = G.C.WHITE, scale = 0.4}},
                        }},
                        {n = G.UIT.R, config = {align = "cm", minh = 0.2}, nodes = {
                            {n = G.UIT.T, config = {text = "Spacer", colour = G.C.WHITE, scale = 0.4}},
                        }},
                        {n = G.UIT.R, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.CHIPS}, nodes = {
                            {n = G.UIT.T, config = {text = "Last Challenge", colour = G.C.WHITE, scale = 0.4}},
                        }}
                    }},
                }},
                {n = G.UIT.R,
                config = {align = "cl", padding = 0.2, colour = G.C.ORANGE},
                nodes = {
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 8, minh = 1, colour = G.C.BLUE}, nodes = {
                        {n = G.UIT.T, config = {text = "< Stake Select >", colour = G.C.WHITE, scale = 0.4}},
                    }},
                    {n = G.UIT.C, config = {align = "cm", minw = 1}, nodes = {
                        {n = G.UIT.T, config = {text = "Spacer", colour = G.C.WHITE, scale = 0.4}},
                    }},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.BOOSTER}, nodes = {
                            {n = G.UIT.T, config = {text = "Last Stake", colour = G.C.WHITE, scale = 0.4}},
                    }}
                }},
                {n = G.UIT.R,
                config = {align = "cr", padding = 0.2, colour = G.C.PURPLE},
                nodes = {
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 8, minh = 1, colour = G.C.FILTER}, nodes = {
                        {n = G.UIT.T, config = {text = "Seed Input", colour = G.C.WHITE, scale = 0.4}},
                    }},
                    {n = G.UIT.C, config = {align = "cm", minw = 1}, nodes = {
                        {n = G.UIT.T, config = {text = "Spacer", colour = G.C.WHITE, scale = 0.4}},
                    }},
                    {n = G.UIT.C, config = {align = "cm", r = 0.1, minw = 4, minh = 1, colour = G.C.ETERNAL}, nodes = {
                            {n = G.UIT.T, config = {text = "Play", colour = G.C.WHITE, scale = 0.4}},
                    }}
                }}
            }}
        }
    }

    return chaldur_screen
end

-- Create the Chaldur screen challenge selection grid
function generate_challenge_select_ui()
    local challenge_grid = {n = G.UIT.C, config = {align = "cm", minh = 3.3, minw = 5}, nodes = {}}
    local count = 1
    for i = 1, 2 do
        local challenge_row = {n = G.UIT.R, config = {colour = G.C.LIGHT}, nodes = {}}

        for j = 1, 6 do
            if count > #G.CHALLENGES then return end
            local challenge_slot_card_area = CardArea(G.ROOM.T.w, G.ROOM.T.h, G.CARD_W, G.CARD_H, {card_limit = 1, type = 'deck'})

            local challenge_slot = {
                n = G.UIT.C, config = {align = "cm"}, nodes = {
                    {n = G.UIT.O,
                    config = {
                        object = challenge_slot_card_area},
                        id = "challenge_"..count,
                    }
                }}
            table.insert(challenge_row.nodes, challenge_slot)
            count = count + 1
            local challenge_card = Card(challenge_slot_card_area.T.x, challenge_slot_card_area.T.y, G.CARD_W, G.CARD_H, G.P_CENTER_POOLS.Back[1], G.P_CENTER_POOLS.Back[1])
            challenge_slot_card_area:emplace(challenge_card)
        end
        table.insert(challenge_grid.nodes, challenge_row)
    end

    return {n = G.UIT.R, config = {align = "cm", r = 0.1, colour = G.C.GREY}, nodes = {
                challenge_grid
            }}
end