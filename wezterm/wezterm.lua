local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action

local purple = '#b16286'

config.color_scheme = 'Gruvbox dark, hard (base16)'
config.font = wezterm.font 'Berkeley Mono'

CTRL_SUPER = 'CTRL | SUPER'

config.keys = {
  {
    key = 'h',
    mods = CTRL_SUPER,
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'l',
    mods = CTRL_SUPER,
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'n',
    mods = CTRL_SUPER,
    action = act.SpawnTab('DefaultDomain'),
  },
  {
    key = "CapsLock",
    mods = "",
    action = wezterm.action.SendKey { key = "Escape" },
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

config.enable_wayland = true

return config
