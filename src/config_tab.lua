-- Mod config tab

Chaldur.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 4, align = "tm", padding = 0.2, colour = G.C.BLACK}, nodes = {
            {n=G.UIT.R, config = {align = 'cm'}, nodes={
                create_toggle({label = localize('chaldur_enable'), ref_table = Chaldur.config, ref_value = 'use', info = localize('chaldur_enable_description'), active_colour = Chaldur.badge_colour, right = true}),
            }},
            {n=G.UIT.R, config={minh=0.1}},
            {n=G.UIT.R, config = {minh = 0.04, minw = 4.5, colour = G.C.L_BLACK}},
            {n=G.UIT.R, nodes = {
                {n=G.UIT.C, config={minw = 3, padding=0.2}, nodes={
                    create_toggle({label = localize('chaldur_enable_animations'), ref_table = Chaldur.config, ref_value = 'animation', info = localize('chaldur_enable_animations_description'), active_colour = Chaldur.badge_colour, right = true}),
                    create_toggle({label = localize('chaldur_reduce'), ref_table = Chaldur.config, ref_value = 'reduce', info = localize('chaldur_reduce_description'), active_colour = Chaldur.badge_colour, right = true}),
                    create_toggle({label = localize('chaldur_unlock'), ref_table = Chaldur.config, ref_value = 'unlock_all', info = localize('chaldur_unlock_description'), active_colour = Chaldur.badge_colour, right = true}),
                }},
                {n=G.UIT.C, config={minw = 3, padding=0.1}, nodes={
                    {n=G.UIT.R, config={minh=0.1}},
                    create_option_cycle({label = localize('chaldur_default_stake'), current_option = Chaldur.config.stake_select, options = localize('chaldur_default_stake_description'), ref_table = Chaldur.config, ref_value = 'stake_select', info = localize('chaldur_default_stake_description'), colour = Chaldur.badge_colour, w = 3.7*0.65/(5/6), h=0.8*0.65/(5/6), text_scale=0.5*0.65/(5/6), scale=5/6, no_pips = true, opt_callback = 'cycle_update'}),
                    create_option_cycle({label = localize('chaldur_stake_fading'), current_option = Chaldur.config.stake_colour, ref_table = Chaldur.config, ref_value = 'stake_colour', options = localize('chaldur_stake_fading_options'), info = localize('chaldur_stake_fading_description'), colour = Chaldur.badge_colour, w = 3.7*0.65/(5/6), h=0.8*0.65/(5/6), text_scale=0.5*0.55/(5/6), scale=5/6, no_pips = true, opt_callback = 'cycle_update'}),
                }}
            }},
    }}
end