local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action

local purple = '#b16286'

config.color_scheme = 'Gruvbox dark, hard (base16)'
config.font = wezterm.font 'Berkeley Mono'

config.leader = {
  key = 'Space',
  mods = 'SHIFT',
}

config.keys = {
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 't',
    mods = 'LEADER',
    action = act.SpawnTab('DefaultDomain'),
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.CloseCurrentTab({ confirm = false }),
  },
}

--
-- Tab bar config
--

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    background = purple,

    active_tab = {
      bg_color = '#3c3836',
      fg_color = purple,
    },
  },
}

config.use_dead_keys = false

config.enable_wayland = false

return config
