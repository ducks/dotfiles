-----------------------------------
-- gruvbox-squares awesome theme --
-----------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/"

local theme = {}

local theme_name = "gruvbox-squares"

theme.font              = "Noto Sans Regular 12"
theme.notification_font = "Noto Sans Bold 14"

theme.red           = "#cc241d"
theme.orange        = "#d65d0e"
theme.yellow        = "#d79921"
theme.green         = "#98971a"

theme.bg_normal     = "#282828"
theme.bg_focus      = "#3c3836"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#28282800"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#a89984"
theme.fg_focus      = "#ebdbb2"
theme.fg_urgent     = "#fbf1c7"
theme.fg_minimize   = "#fbf1c7"

theme.useless_gap   = dpi(1)
theme.border_width  = dpi(1)
theme.border_normal = "#1d2021"
theme.border_focus  = "#ebdbb2"
theme.border_marked = "#91231c"

theme.hotkeys_modifiers_bg = theme.bg_normal
theme.hotkeys_modifiers_fg = theme.fg_normal

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. theme_name .. "/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal =
themes_path .. theme_name .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  =
themes_path .. theme_name .. "/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal =
themes_path .. theme_name .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  =
themes_path .. theme_name .. "/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive =
themes_path .. theme_name .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  =
themes_path .. theme_name .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active =
themes_path .. theme_name .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  =
themes_path .. theme_name .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive =
themes_path .. theme_name .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  =
themes_path .. theme_name .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active =
themes_path .. theme_name .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  =
themes_path .. theme_name .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive =
themes_path .. theme_name .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  =
themes_path .. theme_name .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active =
themes_path .. theme_name .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  =
themes_path .. theme_name .. "/titlebar/floating_focus_active.png"


theme.titlebar_maximized_button_normal_inactive =
themes_path .. theme_name .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  =
themes_path .. theme_name .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active =
themes_path .. theme_name .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  =
themes_path .. theme_name .. "/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path .. theme_name .. "/background.png"

theme.layout_txt_tile = "[t]"
theme.layout_txt_floating = "[f]"
theme.layout_txt_fairv = "[fv]"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
