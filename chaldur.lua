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

-- local card_stop_hover = Card.stop_hover
-- -- Adds logic to vanilla Card.stop_hover function.
-- function Card:stop_hover()
--     if self.params.stake_chip then
--         Galdur.hover_index = 0
--     end
--     card_stop_hover(self)
-- end

-- local card_hover_ref = Card.hover
-- -- Adds logic to vanilla Card.hover function.
-- function Card:hover()
--     if self.params.deck_select and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui and not G.debug_tooltip_toggle then
--         self:juice_up(0.05, 0.03)
--         play_sound('paper1', math.random()*0.2 + 0.9, 0.35)
--         if self.children.alert and not self.config.center.alerted then
--             self.config.center.alerted = true
--             G:save_progress()
--         end

--         local col = self.params.deck_preview and G.UIT.C or G.UIT.R
--         local info_col = self.params.deck_preview and G.UIT.R or G.UIT.C
--         local back = Back(self.config.center)

--         local info_queue = populate_info_queue('Back', back.effect.center.key)
--         local tooltips = {}
--         if self.config.center.unlocked then
--             for _, center in pairs(info_queue) do
--                 local desc = generate_card_ui(center, {main = {},info = {},type = {},name = 'done',badges = badges or {}}, nil, center.set, nil)
--                 tooltips[#tooltips + 1] =
--                 {n=info_col, config={align = self.params.deck_preview and 'tr' or self.params.deck_select > 6 and 'bm' or "tm"}, nodes={
--                     {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
--                     info_tip_from_rows(desc.info[1], desc.info[1].name),
--                     }}
--                 }}
--             end
--         end
--         local badges = {n=G.UIT.ROOT, config = {colour = G.C.CLEAR, align = 'cm'}, nodes = {}}
--         SMODS.create_mod_badges(self.config.center, badges.nodes)
--         if badges.nodes.mod_set then badges.nodes.mod_set = nil end

--         self.config.h_popup = {n=G.UIT.C, config={align = "cm", padding=0.1}, nodes={
--             (self.params.deck_select > 6 and {n=col, config={align='cm', padding=0.1}, nodes = tooltips} or {n=G.UIT.R}),
--             {n=col, config={align=(self.params.deck_preview and 'bm' or 'cm')}, nodes = {
--                 {n=G.UIT.C, config={align = "cm", minh = 1.5, r = 0.1, colour = G.C.L_BLACK, padding = 0.1, outline=1}, nodes={
--                     {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 3, maxw = 4, minh = 0.4}, nodes={
--                         {n=G.UIT.O, config={object = UIBox{definition =
--                             {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
--                                 {n=G.UIT.O, config={object = DynaText({string = back:get_name(),maxw = 4, colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.5, pop_in = 0, silent = true})}},
--                             }},
--                         config = {offset = {x=0,y=0}, align = 'cm', parent = e}}}
--                         },
--                     }},
--                     {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, minh = 1.3, maxh = 3, minw = 3, maxw = 4, r = 0.1}, nodes={
--                         {n=G.UIT.O, config={object = UIBox{definition = back:generate_UI(), config = {offset = {x=0,y=0}}}}}
--                     }},
--                     badges.nodes[1] and {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 3, maxw = 4, minh = 0.4}, nodes={
--                         {n=G.UIT.O, config={object = UIBox{definition = badges, config = {offset = {x=0,y=0}}}}}
--                     }},
--                 }}
--             }},
--             (self.params.deck_select < 7 and {n=col, config={align=(self.params.deck_preview and 'bm' or 'cm'), padding=0.1}, nodes = tooltips} or {n=G.UIT.R})

--         }}
--         self.config.h_popup_config = self:align_h_popup()

--         Node.hover(self)
--     elseif self.params.stake_chip and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui and not G.debug_tooltip_toggle then
--         Galdur.hover_index = self.params.hover or 0
--         self:juice_up(0.05, 0.03)
--         play_sound('paper1', math.random()*0.2 + 0.9, 0.35)

--         local info_queue = populate_info_queue('Stake', G.P_CENTER_POOLS.Stake[self.params.stake].key)
--         local tooltips = {}
--         for _, center in pairs(info_queue) do
--             local desc = generate_card_ui(center, {main = {},info = {},type = {},name = 'done'}, nil, center.set, nil)
--             tooltips[#tooltips + 1] =
--             {n=G.UIT.C, config={align = "bm"}, nodes={
--                 {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
--                     info_tip_from_rows(desc.info[1], desc.info[1].name),
--                 }}
--             }}
--         end

--         local badges = {n=G.UIT.ROOT, config = {colour = G.C.CLEAR, align = 'cm'}, nodes = {}}
--         SMODS.create_mod_badges(G.P_CENTER_POOLS.Stake[self.params.stake], badges.nodes)
--         if badges.nodes.mod_set then badges.nodes.mod_set = nil end


--         self.config.h_popup = self.params.stake_chip_locked and {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1, outline = 1}, nodes={
--             {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, colour = G.C.L_BLACK}, nodes={
--                 {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
--                     {n=G.UIT.T, config={text = localize('gald_locked'), scale = 0.4, colour = G.C.WHITE}}
--                 }},
--                 {n=G.UIT.R, config={align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1, minh = 1, minw = 3.5}, nodes=
--                     create_stake_unlock_message(G.P_CENTER_POOLS.Stake[self.params.stake])
--                 }
--             }}
--         }} or {n = G.UIT.ROOT, config={align='cm', colour = G.C.CLEAR}, nodes = {
--             {n=G.UIT.R, config={align='cm', padding=0.1}, nodes = tooltips},
--             {n=G.UIT.C, config={align = "cm", padding = 0.1, colour = G.C.BLACK, r = 0.1, outline = 1}, nodes={
--                 {n=G.UIT.R, nodes = {
--                     {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
--                         {n=G.UIT.T, config={text = localize('k_stake'), scale = 0.4, colour = G.C.L_BLACK, vert = true}}
--                     }},
--                     {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
--                         {n=G.UIT.O, config={colour = G.C.BLUE, object = get_stake_sprite(self.params.stake), hover = true, can_collide = false}},
--                     }},
--                     {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
--                         G.UIDEF.stake_description(self.params.stake)
--                     }}
--                 }},
--                 badges.nodes[1] and {n=G.UIT.R, config={ align = "cm"}, nodes={
--                     {n=G.UIT.O, config={object = UIBox{definition = badges, config = {offset = {x=0,y=0}}}}}
--                 }},
--             }}
--         }}

--         self.config.h_popup_config = self:align_h_popup()
--         Node.hover(self)
--     else
--         card_hover_ref(self)
--     end
-- end

-- local card_click_ref = Card.click
-- -- Adds logic to vanilla Card.click function.
-- function Card:click()
--     if self.deck_select_position and self.config.center.unlocked then
--         Galdur.run_setup.selected_deck_from = self.area.config.index
--         Galdur.run_setup.choices.deck = Back(self.config.center)
--         -- Galdur.run_setup.choices.stake = get_deck_win_stake(Galdur.run_setup.choices.deck.effect.center.key)
--         Galdur.set_new_deck()
--     elseif self.params.stake_chip and not self.params.stake_chip_locked then
--         Galdur.run_setup.choices.stake = self.params.stake
--         G.E_MANAGER:clear_queue('galdur')
--         Galdur.populate_chip_tower(self.params.stake)
--     else
--         card_click_ref(self)
--     end
-- end

-- local exit_overlay = G.FUNCS.exit_overlay_menu
-- -- Adds logic to vanilla G.FUNCS.exit_overlay_menu function.
-- -- Cleans up Chaldur stuff before exiting the Chaldur overlay.
-- G.FUNCS.exit_overlay_menu = function()
--     if Galdur.config.use and (Galdur.run_setup.deck_select_areas or Galdur.run_setup.stake_select_areas) then
--         for _, clean_up in pairs(Galdur.clean_up_functions) do
--             clean_up()
--         end
--         G.E_MANAGER:clear_queue('galdur')
--     end
--     exit_overlay()
-- end


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
    local t = {
        n = G.UIT.ROOT,
        config = {
            minh = 0.6,
            minw = 2,
            maxw = 2
        }
    }
end

-- Set up initial choices for the Chaldur overlay.
-- function Chaldur.prepare_challenge_setup()
--     Chaldur.challenge_setup.choices.challenge = G.CHALLENGES.1
-- end

-- Main select functions



-- Challenge preview functions



-- Function overrides
