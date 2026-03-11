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

assert(SMODS.load_file('src/config_tab.lua'))()
assert(SMODS.load_file('utils/CodaUtility.lua'))()

-- Mod variable definitions
Chaldur.challenge_setup = {
    choices = {
        challenge = nil,
        stake = nil,
        seed = nil,
        seed_temp = ''
    },
    challenge_select_areas = {},
    current_challenge_page = 1,
    stake_select_areas = {},
    current_stake_page = 1,
}

Chaldur.test_mode = true

-- ### UI Creation ###

-- Global variables
local spacing = 0.18

-- Create the Chaldur screen UI definition
function G.UIDEF.challenge_setup_option(from_game_over)
    local chaldur_screen = {
        n = G.UIT.ROOT,
        config = {align = 'cm'},
        nodes = {
            {n = G.UIT.C,
            nodes = {
                {n = G.UIT.R, -- ROW 1: Challenge Select, Challenge Preview, Challenge Page Switcher, Random Challenge, Last Challenge
                config = {align = 'cl'},
                nodes = {
                    {n = G.UIT.C, config = {align = 'cm', r = 0.1, padding = spacing, colour = G.C.BLACK}, nodes = {
                        {n = G.UIT.R, nodes = {
                            {n = G.UIT.C, config = {align = 'cm'}, nodes = {
                                create_challenge_select_page_ui(),
                                {n = G.UIT.R, config = {minh = spacing}},
                                create_challenge_select_page_cycler()
                            }}
                        }}
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C,
                    config = {align = 'cm'},
                    nodes = {
                        {n = G.UIT.R, config = {align = 'cm', r = 0.1, minw = 4, colour = G.C.BLACK}, nodes = {
                            {n = G.UIT.C, config = {align = 'cm'}, nodes = {
                                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                                    {n = G.UIT.T, config = {text = 'Challenge Name', colour = G.C.WHITE, scale = 0.4}},
                                }},
                                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                                    {n = G.UIT.T, config = {text = 'Preview', colour = G.C.WHITE, scale = 0.4}},
                                }},
                                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                                    {n = G.UIT.T, config = {text = 'SELECTED', colour = G.C.WHITE, scale = 0.4}},
                                }}
                            }},
                        }},
                        {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                        {n = G.UIT.R, config = {align = 'cm', r = 0.1, padding = spacing, colour = G.C.BLACK}, nodes = {
                            {n = G.UIT.C, config = {align = 'cm', r = 0.1, minw = 2, minh = 0.5, colour = G.C.CHANCE}, nodes = {
                                {n = G.UIT.T, config = {text = 'Random', colour = G.C.WHITE, scale = 0.4}}
                            }},
                            {n = G.UIT.C, config = {align = 'cm', r = 0.1, minw = 2, minh = 0.5, colour = G.C.CHIPS}, nodes = {
                                {n = G.UIT.T, config = {text = 'Last', colour = G.C.WHITE, scale = 0.4}}
                            }}
                        }}
                    }},
                }},
                {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                {n = G.UIT.R, -- ROW 2: Stake Select, Stake Preview, Stake Page Switcher, Random Stake, Last Stake
                config = {align = 'cl'},
                nodes = {
                    {n = G.UIT.C, config = {align = 'cm', r = 0.1, padding = spacing, colour = G.C.BLACK}, nodes = {
                        {n = G.UIT.R, nodes = {
                            {n = G.UIT.C, config = {align = 'cm'}, nodes = {
                                create_stake_select_page_ui(),
                                {n = G.UIT.R, config = {minh = spacing}},
                                create_stake_select_page_cycler()
                            }}
                        }}
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C,
                    config = {align = 'cm'},
                    nodes = {
                        {n = G.UIT.R, config = {align = 'cm', r = 0.1, minw = 4, colour = G.C.BLACK}, nodes = {
                            {n = G.UIT.C, config = {align = 'cm'}, nodes = {
                                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                                    {n = G.UIT.T, config = {text = 'Stake Name', colour = G.C.WHITE, scale = 0.4}},
                                }},
                                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                                    {n = G.UIT.T, config = {text = 'Preview', colour = G.C.WHITE, scale = 0.4}},
                                }},
                                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                                    {n = G.UIT.T, config = {text = 'SELECTED', colour = G.C.WHITE, scale = 0.4}},
                                }}
                            }},
                        }},
                        {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                        {n = G.UIT.R, config = {align = 'cm', r = 0.1, padding = spacing, colour = G.C.BLACK}, nodes = {
                            {n = G.UIT.C, config = {align = 'cm', r = 0.1, minw = 2, minh = 0.5, colour = G.C.CHANCE}, nodes = {
                                {n = G.UIT.T, config = {text = 'Random', colour = G.C.WHITE, scale = 0.4}}
                            }},
                            {n = G.UIT.C, config = {align = 'cm', r = 0.1, minw = 2, minh = 0.5, colour = G.C.CHIPS}, nodes = {
                                {n = G.UIT.T, config = {text = 'Last', colour = G.C.WHITE, scale = 0.4}}
                            }}
                        }}
                    }}
                }},
                {n = G.UIT.R, config = {minh = spacing}, nodes = {}},
                {n = G.UIT.R, -- ROW 3: Seed Input, Play
                config = {align = 'cl'},
                nodes = {
                    {n = G.UIT.C, config = {align = 'cm', r = 0.1, minw = 8, minh = 1, colour = G.C.FILTER}, nodes = {
                        {n = G.UIT.T, config = {text = 'Seed Input', colour = G.C.WHITE, scale = 0.4}}
                    }},
                    {n = G.UIT.C, config = {minw = spacing}, nodes = {}},
                    {n = G.UIT.C, config = {align = 'cm', r = 0.1, minw = 4, minh = 1, colour = G.C.ETERNAL}, nodes = {
                        {n = G.UIT.T, config = {text = 'Play', colour = G.C.WHITE, scale = 0.4}}
                    }}
                }}
            }}
        }
    }

    return chaldur_screen
end

-- Generate the challenge select page card areas
function generate_challenge_select_page_card_areas()
    
end

-- Create the challenge select page
function create_challenge_select_page_ui()
    local challenge_grid = {n = G.UIT.C, nodes = {}}
    local challenge_ui = {n = G.UIT.R, nodes = {challenge_grid}}
    local count = 1
    for i = 1, 2 do
        local challenge_row = {n = G.UIT.R, config = {align = 'cm'}, nodes = {}}

        for j = 1, 5 do
            if count > #G.CHALLENGES then return end
            Chaldur.challenge_setup.challenge_select_areas[count] = CardArea(G.ROOM.T.w, G.ROOM.T.h, G.CARD_W, G.CARD_H, {type = 'deck'})
            local challenge_slot = {
                n = G.UIT.C, nodes = {
                    {n = G.UIT.O, config = {object = Chaldur.challenge_setup.challenge_select_areas[count]}, id = 'challenge_'..count}
                }
            }
            table.insert(challenge_row.nodes, challenge_slot)
            count = count + 1
        end
        table.insert(challenge_grid.nodes, challenge_row)
    end

    populate_challenge_select_page(Chaldur.challenge_setup.current_challenge_page)

    return challenge_ui
end

-- Populate the challenge select page with challenge cards
function populate_challenge_select_page(page)
    local count = 1 + (page - 1) * 10
    for i = 1, 10 do
        if count > #G.CHALLENGES then return end
        local challenge_card = Card(Chaldur.challenge_setup.challenge_select_areas[i].T.x, Chaldur.challenge_setup.challenge_select_areas[i].T.y, G.CARD_W, G.CARD_H, G.P_CENTERS.b_challenge, G.P_CENTERS.b_challenge)
        challenge_card.sprite_facing = 'back'
        challenge_card.facing = 'back'
        challenge_card.children.back = Sprite(challenge_card.T.x, challenge_card.T.y, challenge_card.T.w, challenge_card.T.h, G.ASSET_ATLAS[G.P_CENTERS.b_challenge.unlocked and G.P_CENTERS.b_challenge.atlas or 'centers'], G.P_CENTERS.b_challenge.unlocked and G.P_CENTERS.b_challenge.pos or {x = 4, y = 0})
        challenge_card.children.back.states.collide.can = false
        challenge_card.children.back:set_role({major = challenge_card, role_type = 'Glued', draw_major = challenge_card})
        Chaldur.challenge_setup.challenge_select_areas[i]:emplace(challenge_card)
        count = count + 1
    end
end

-- Clear the stake select page of stake cards
function clear_challenge_select_page()
    if not Chaldur.challenge_setup.challenge_select_areas then return end
    for i = 1, #Chaldur.challenge_setup.challenge_select_areas do
        if Chaldur.challenge_setup.challenge_select_areas[i].cards then
            remove_all(Chaldur.challenge_setup.challenge_select_areas[i].cards)
            Chaldur.challenge_setup.challenge_select_areas[i].cards = {}
        end
    end
end

-- Create the challenge select page cycler
function create_challenge_select_page_cycler()
    local challenge_cycler = CodaUtility.page_cycler({
        object_table = G.CHALLENGES,
        page_size = 10,
        key = 'challenge_cycler',
        switch_func = G.FUNCS.change_challenge_select_page,
        colour = G.C.RED
    })

    return challenge_cycler
end

G.FUNCS.change_challenge_select_page = function(args)
    clear_challenge_select_page()
    populate_challenge_select_page(args.to)
end

-- Generate the stake select page card areas
function generate_stake_select_page_card_areas()
    
end

-- Create the stake select page
function create_stake_select_page_ui()
    local stake_row = {n = G.UIT.R, config = {align = 'cm', minw = G.CARD_W * 5}, nodes = {}}
    local count = 1
    for i = 1, 8 do
        if count > #G.P_CENTER_POOLS.Stake then return end
        Chaldur.challenge_setup.stake_select_areas[i] = CardArea(G.ROOM.T.w * 0.116, G.ROOM.T.h * 0.209, G.CARD_W * 5 / 8, G.CARD_W * 5 / 8, {type = 'deck'})
        local stake_slot = {
            n = G.UIT.C, nodes = {
                {n = G.UIT.O, config = {object = Chaldur.challenge_setup.stake_select_areas[i]}, id = 'stake_'..count}
            }
        }
        table.insert(stake_row.nodes, stake_slot)
        count = count + 1
    end

    populate_stake_select_page(Chaldur.challenge_setup.current_stake_page)

    return stake_row
end

-- Populate the stake select page with stake cards
function populate_stake_select_page(page)
    local count = 1 + (page - 1) * 8
    for i = 1, 8 do
        if count > #G.P_CENTER_POOLS.Stake then return end
        local stake_card = Card(Chaldur.challenge_setup.stake_select_areas[i].T.x, Chaldur.challenge_setup.stake_select_areas[i].T.y, 3.4*14/41, 3.4*14/41, G.P_CENTERS.b_red, G.P_CENTERS.b_red)
        stake_card.sprite_facing = 'back'
        stake_card.facing = 'back'
        stake_card.children.back = Sprite(stake_card.T.x, stake_card.T.y, 3.4*14/41, 3.4*14/41, G.ASSET_ATLAS[G.P_CENTER_POOLS.Stake[i].atlas], G.P_CENTER_POOLS.Stake[i].pos)
        stake_card.children.back.states.collide.can = false
        stake_card.children.back:set_role({major = stake_card, role_type = 'Glued', draw_major = stake_card})
        Chaldur.challenge_setup.stake_select_areas[i]:emplace(stake_card)
        count = count + 1
    end
end

-- Clear the stake select page of stake cards
function clear_stake_select_page()
    if not Chaldur.challenge_setup.stake_select_areas then return end
    for i = 1, #Chaldur.challenge_setup.stake_select_areas do
        if Chaldur.challenge_setup.stake_select_areas[i].cards then
            remove_all(Chaldur.challenge_setup.stake_select_areas[i].cards)
            Chaldur.challenge_setup.stake_select_areas[i].cards = {}
        end
    end
end

-- Create the stake select page cycler
function create_stake_select_page_cycler()
    local stake_cycler = CodaUtility.page_cycler({
        object_table = G.P_CENTER_POOLS.Stake,
        page_size = 8,
        key = 'stake_cycler',
        switch_func = G.FUNCS.change_stake_select_page,
        colour = G.C.RED
    })

    return {n = G.UIT.R, config = {align = 'cm'}, nodes = {stake_cycler}}
end

G.FUNCS.change_stake_select_page = function(args)
    clear_stake_select_page()
    populate_stake_select_page(args.to)
end

-- Testing code
if Chaldur.test_mode then
    for i = 1, 24 do
        SMODS.Challenge({
            key = 'test_challenge_'..i
        })
    end

    SMODS.Stake({
        key = 'test_stake',
        applied_stakes = {'cry_brown', 'galdur_test_10'},
        above_stake = ('galdur_test_10'),
        pos = { x = 4, y = 1 },
        loc_txt = {
            name = 'Test Stake FINAL',
            text = {
            'Required {T:m_wild}score {T:e_foil}scales',
            'faster for {T:j_jolly}each {C:attention}Ante'
            }
        },
        sticker_pos = {x = 1, y = 0},
        sticker_atlas = 'sticker',
        shiny = true
    })
end