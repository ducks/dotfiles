local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Gruvbox dark, hard (base16)'
config.font = wezterm.font 'Berkeley Mono'

--
-- Tab bar config
--

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    background = '#98971a',

    active_tab = {
      bg_color = '#3c3836',
      fg_color = '#fe8019',
    },
  },
}

config.use_dead_keys = false

return config
