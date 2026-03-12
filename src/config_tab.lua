-- Mod config tab

Chaldur.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 4, align = "tm", padding = 0.2, colour = G.C.BLACK}, nodes = {
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
            create_toggle({label = localize('chaldur_enable'), ref_table = Chaldur.config, ref_value = 'use', info = localize('chaldur_enable_description'), active_colour = Chaldur.badge_colour, right = true}),
        }}
    }}
end