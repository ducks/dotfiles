local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action

local purple = '#b16286'

config.color_scheme = 'Gruvbox dark, hard (base16)'
config.font = wezterm.font 'Berkeley Mono'

local mod = 'CTRL | {{ MOD }}'

config.keys = {
  {
    key = 'h',
    mods = mod,
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'l',
    mods = mod,
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'n',
    mods = mod,
    action = act.SpawnTab('DefaultDomain'),
  },
  {
    key = 'w',
    mods = mod,
    action = act.CloseCurrentTab { confirm = true },
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

config.harfbuzz_features = {
  "liga=0",
  "clig=0",
  "calt=0",
}

return config
