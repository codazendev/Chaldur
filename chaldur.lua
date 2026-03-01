-- Mod icon
SMODS.Atlas({
    key = 'modicon',
    path = 'chaldur_icon.png',
    px = 32,
    py = 32
})

-- Definitions
Chaldur = SMODS.current_mod
Chaldur.config = SMODS.current_mod.config

Chaldur.run_setup = {
    choices = {
        deck = nil,
        stake = nil,
        seed = nil,
        seed_temp = ''
    },
    deck_select_areas = {},
    current_page = 1,
    pages = {},
    selected_deck_height = 52,
}
Chaldur.hover_index = 0

Chaldur.test_mode = true

-- Chaldur event queue
G.E_MANAGER.queues.chaldur = {}

-- Load Chaldur config tab
SMODS.load_file("src/config_tab.lua")()

-- Function hooks

-- Challenge select functions
function G.UIDEF.challenges_new_model(from_game_over)
    if G.PROFILES[G.SETTINGS.profile].all_unlocked then G.PROFILES[G.SETTINGS.profile].challenges_unlocked = #G.CHALLENGES end

    if not G.PROFILES[G.SETTINGS.profile].challenges_unlocked then
        local deck_wins = 0
        for k, v in pairs(G.PROFILES[G.SETTINGS.profile].deck_usage) do
            if v.wins and v.wins[1] then
                deck_wins = deck_wins + 1
            end
        end
        local loc_nodes = {}
        localize{type = 'descriptions', key = 'challenge_locked', set = 'Other', nodes = loc_nodes, vars = {G.CHALLENGE_WINS, deck_wins}, default_col = G.C.WHITE}

        return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8.02, minw = 7}, nodes={
            transparent_multiline_text(loc_nodes)
        }}
    end

    G.run_setup_seed = nil
    if G.OVERLAY_MENU then 
        local seed_toggle = G.OVERLAY_MENU:get_UIE_by_ID('run_setup_seed')
        if seed_toggle then seed_toggle.states.visible = false end
    end

    local _ch_comp, _ch_tot = 0,#G.CHALLENGES
    for k, v in ipairs(G.CHALLENGES) do
        if v.id and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[v.id or ''] then
            _ch_comp = _ch_comp + 1
        end
    end

    local _ch_tab = {comp = _ch_comp, unlocked = G.PROFILES[G.SETTINGS.profile].challenges_unlocked}

    return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8, minw = 7}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1 ,colour = G.C.BLACK}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.T, config={text = localize('k_challenge_mode'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", minw = 8.5, minh = 1.5, padding = 0.2}, nodes={
                UIBox_button({id = from_game_over and 'from_game_over' or nil, label = {localize('b_new_challenge')}, button = 'challenge_list', minw = 4, scale = 0.4, minh = 0.6}),
            }},
            {n=G.UIT.R, config={align = "cm", minh = 0.8, r = 0.1, minw = 4.5, colour = G.C.L_BLACK, emboss = 0.05,
            progress_bar = {
                max = _ch_tot, ref_table = _ch_tab, ref_value = 'unlocked', empty_col = G.C.L_BLACK, filled_col = G.C.FILTER
            }}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, minw = 4.5}, nodes={
                    {n=G.UIT.T, config={text = localize{type = 'variable', key = 'unlocked', vars = {_ch_tab.unlocked, _ch_tot}}, scale = 0.3, colour = G.C.WHITE, shadow =true}},
                }},
            }},
        }},
        G.F_DAILIES and {n=G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1 ,colour = G.C.BLACK}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.T, config={text = localize('k_daily_run'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cl", minw = 8.5, minh = 4}, nodes={
                G.UIDEF.daily_overview()
            }}
        }} or nil,
    }}
end

-- Main select functions

-- Challenge preview functions

-- Function overrides