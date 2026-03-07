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
    -- Add any valid pages in pages to add
    -- Clear pages to add

    -- Load saved game if it exists

    -- Call prepare challenge
    -- Use MEMORY to set the initial choices of the challenge screen (deck, stake, seed) (in my case it'll be challenge, stake, seed, I think)
    -- Set current challenge type (?)

    -- Set up deck preview thing (deck names are split so it works, going to find a better way personally)

    -- Call generate deck card areas
    -- Call generate stake card areas

    -- Some quick start stuff that I'll worry about once MVP is done
    local chaldur_screen = {
        n = G.UIT.ROOT,
        config = {
            align = "cm", minh = 2.2, minw = 5
        },
        nodes = {}
    }

    -- Chaldur screen should contain:
    -- challenge selection panel
    -- page swapper for challenge selection
    -- challenge preview panel
    -- row of buttons: seed, stake, play, and last challenge above that somewhere

    return chaldur_screen
end

function generate_challenge_card_areas_ui()
    local challenge_grid = {n = G.UIT.R, config = {align = "cm", minh = 3.3, minw = 5}, nodes = {}}
    local count = 1
    for i = 0, 1 do
        local challenge_row = {n = G.UIT.R, config = {colour = G.C.LIGHT}, nodes = {}}

        for j = 0, 5 do
            if count > #G.CHALLENGES then return end

            local challenge_slot = {n = G.UIT.O, config = {Object = Chaldur.challenge_setup.challenge_select_areas[count], r = 0.1, id = "challenge_select_"..count, focus_args = {snap_to = true}},}
            table.insert(row.nodes, challenge_slot)
            count = count + 1
        end
        table.insert(challenge_grid.nodes, challenge_row)
    end

    return challenge_grid
end

-- Set up initial choices for the Chaldur overlay.
-- function Chaldur.prepare_challenge_setup()
--     Chaldur.challenge_setup.choices.challenge = G.CHALLENGES.1
-- end

-- Main select functions



-- Challenge preview functions



-- Function overrides
