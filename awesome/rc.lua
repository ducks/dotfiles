-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")

local lain = require("lain")
local markup = lain.util.markup

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end
-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, an error happened!",
    text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Chosen colors and buttons look alike adapta maia theme
-- beautiful.init("./themes/dinitar-fog/theme.lua")
beautiful.init("~/.config/awesome/themes/gruvbox-squares/theme.lua")

-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "mousepad"
-- terminal = "alacritty"
terminal = "/home/urho/dev/rust/wezterm/target/release/wezterm"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.fair,
}
-- }}}

local spacer = wibox.widget.textbox(' ')
local spacer_5 = wibox.widget.textbox('     ')

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil
  return function ()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = 250 } })
    end
  end
end
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() return false, hotkeys_popup.show_help end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
  { "manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
  { "edit config", gui_editor .. " " .. awesome.conffile, menubar.utils.lookup_icon("accessories-text-editor") },
  { "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}
myexitmenu = {
  { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
  { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
  { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
  { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
  { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}
mymainmenu = freedesktop.menu.build({
  icon_size = 32,
  before = {
    { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
    { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
    { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
    -- other triads can be put here
  },
  after = {
    { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
    { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
    -- other triads can be put here
  }
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget {
  font = beautiful.font,
  format = "%a %b %d, %H:%M:%S",
  refresh = 1,
  widget = wibox.widget.textclock,
}

local month_calendar_styles = {
  halign = "center"
}

local month_calendar_options = {
  start_sunday = true,
  long_weekdays = true,
  style_normal = month_calendar_styles,
  style_focus = month_calendar_styles,
}

local month_calendar = awful.widget.calendar_popup.month(month_calendar_options)

month_calendar:attach(mytextclock, "tr", { on_hover = false })

-- {{{ Update text widget
-- Creates a text widget that shows a ! if there are updates available

local update_widget = wibox.widget {
  {
    id = "uw",
    font = beautiful.notification_font,
    markup = "<b>!</b>",
    halign = "center",
    valign = "center",
    visible = false,
    widget = wibox.widget.textbox
  },
  fg = beautiful.orange,
  widget = wibox.container.background
}

local update_timer =
  awful.widget.watch(
    'checkupdates',
    60,
    function(widget, stdout)
      if string.len(stdout) > 0 then
        widget.visible = true
        return
      else
        widget.visible = false
      end
    end,
    update_widget.uw
  )

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
  if client.focus then
    client.focus:move_to_tag(t)
  end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
  if client.focus then
    client.focus:toggle_tag(t)
  end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
awful.button({ }, 1, function (c)
  if c == client.focus then
    c.minimized = true
  else
    -- Without this, the following
    -- :isvisible() makes no sense
    c.minimized = false
    if not c:isvisible() and c.first_tag then
      c.first_tag:view_only()
    end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
  end
end),
awful.button({ }, 3, client_menu_toggle_fn()),
awful.button({ }, 4, function ()
  awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
  awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

local function update_txt_layoutbox(s)
  -- Writes a string representation of the current layout in a textbox widget
  local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
  s.mytxtlayoutbox:set_text(txt_l)
end

local bat_notification

local bat = lain.widget.bat({
  settings = function()
    if not bat_now.status then return end

    local perc = bat_now.perc
    local text

    if perc > 0 and perc < 26 then
      text = markup(beautiful.red, " ■ ")
    elseif perc >= 26 and perc < 51 then
      text = markup(beautiful.red, " ■ ") .. markup(beautiful.orange, " ■ ")
    elseif perc >= 51 and perc < 76 then
      text = markup(beautiful.red, " ■ ") .. markup(beautiful.orange, " ■ ") .. markup(beautiful.yellow, " ■ ")
    else
      text = markup(beautiful.red, " ■ ") .. markup(beautiful.orange, " ■ ") ..
      markup(beautiful.yellow, " ■ ") .. markup(beautiful.green, " ■ ")
    end

    naughty.destroy(bat_notification)

    widget:set_markup(markup.font(beautiful.font, text))
    widget:connect_signal("mouse::enter", function ()
      naughty.destroy(bat_notification)
      perc = bat_now.perc

      bat_notification = naughty.notify {
        text = tostring(perc .. "%"),
        position = "bottom_right",
      }
    end)
    widget:connect_signal("mouse::leave", function ()
      naughty.destroy(bat_notification)
    end)
  end
})

local net = lain.widget.net({
  notify = "off",
  wifi_state = "on",
  settings = function()
    local wlan0 = net_now.devices.wlp3s0b1

    if wlan0 then
      if wlan0.wifi then
        local signal = wlan0.signal
        local text

        if signal < -83 then
          text = markup(beautiful.red, " ▲ ")
        elseif signal < -53 then
          text = markup(beautiful.yellow, " ▲ ")
        elseif signal >= -53 then
          text = markup(beautiful.green, " ▲ ")
        end

        widget:set_markup(markup.font(beautiful.font, text))
      else
        widget:set_markup(markup.font(beautiful.font, "no wifi"))
      end
    end
  end
})

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "  ■  ", "  ■  ", "  ■  " }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mytxtlayoutbox = wibox.widget {
    markup = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))],
    valign = top,
    widget = wibox.widget.textbox

  }
  awful.tag.attached_connect_signal(s, "property::selected", function ()
    update_txt_layoutbox(s)
  end)

  awful.tag.attached_connect_signal(s, "property::layout", function ()
    update_txt_layoutbox(s)
  end)

  s.mytxtlayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    opacity = 1,
  })

  s.mybottomwibox = awful.wibar({
    height = dpi(16),
    position = "bottom",
    screen = s,
    visible = false
  })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,

    -- Left widgets
    {
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
    },

    -- Middle widget
    {
      layout = wibox.layout.fixed.horizontal,
    },

    -- Right widgets
    {
      layout = wibox.layout.fixed.horizontal,
      update_widget,
      spacer_5,
      mytextclock,
      spacer_5,
    },
  }

    -- Add widgets to the wibox
  s.mybottomwibox:setup {
    layout = wibox.layout.align.horizontal,

    -- Left widgets
    {
      layout = wibox.layout.fixed.horizontal,
      spacer,
      s.mytxtlayoutbox,
    },

    -- Middle widget
    {
      layout = wibox.layout.fixed.horizontal,
    },

    -- Right widgets
    {
      layout = wibox.layout.fixed.horizontal,
      net,
      spacer,
      bat,
      spacer,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 1, function () mymainmenu:hide() end),
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key binding functions
toggle_mybottomwibox = function ()
  local screen = awful.screen.focused()

  screen.mybottomwibox.visible = not screen.mybottomwibox.visible
end
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey }, "s", toggle_mybottomwibox,
  { description="toggle bottom status bar", group="awesome" }),

  awful.key({ modkey }, "/", hotkeys_popup.show_help,
  { description="show help", group="awesome" }),

  awful.key({ modkey }, "Left", awful.tag.viewprev,
  { description = "view previous", group = "tag" }),

  awful.key({ modkey }, "Right", awful.tag.viewnext,
  { description = "view next", group = "tag" }),

  awful.key({ modkey }, "Escape", awful.tag.history.restore,
  { description = "go back", group = "tag" }),

  awful.key({ modkey }, "j", function () awful.client.focus.byidx( 1) end,
  { description = "focus next by index", group = "client"}),

  awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) end,
  { description = "focus previous by index", group = "client"}),

  -- awful.key({ modkey }, "w", function () mymainmenu:toggle() end,
  -- { description = "show main menu", group = "awesome" }),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end,
  { description = "swap with next client by index", group = "client" }),

  awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end,
  { description = "swap with previous client by index", group = "client" }),

  -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(1) end,
  -- { description = "focus the next screen", group = "screen" }),

  -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
  -- { description = "focus the previous screen", group = "screen" }),

  awful.key({ modkey, "Control" }, "j", awful.tag.viewprev,
  { description = "view previous", group = "tag" }),

  awful.key({ modkey, "Control" }, "k", awful.tag.viewnext,
  { description = "view next", group = "tag" }),

  awful.key({ modkey }, "u", awful.client.urgent.jumpto,
  { description = "jump to urgent client", group = "client" }),

  awful.key({ modkey }, "Tab",
  function ()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end,
  { description = "go back", group = "client" }),

  -- Standard program
  awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
  { description = "open a terminal", group = "launcher" }),

  awful.key({ modkey }, "z", function () awful.spawn(terminal) end,
  { description = "open a terminal", group = "launcher" }),

  awful.key({ modkey, "Control" }, "r", awesome.restart,
  { description = "reload awesome", group = "awesome" }),

  awful.key({ modkey, "Shift" }, "q", awesome.quit,
  { description = "quit awesome", group = "awesome" }),

  awful.key({ modkey }, "l", function () awful.tag.incmwfact( 0.05) end,
  { description = "increase master width factor", group = "layout" }),

  awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end,
  { description = "decrease master width factor", group = "layout" }),

  -- awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
  -- { description = "increase the number of master clients", group = "layout" }),

  -- awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
  -- { description = "decrease the number of master clients", group = "layout" }),

  awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true) end,
  { description = "increase the number of columns", group = "layout" }),

  awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end,
  { description = "decrease the number of columns", group = "layout" }),

  awful.key({ modkey }, "b", function () awful.spawn(browser) end,
  { description = "launch Browser", group = "launcher" }),

  awful.key({ modkey, "Control"}, "Escape", function () awful.spawn("/usr/bin/rofi -show drun -modi drun") end,
  { description = "launch rofi", group = "launcher" }),

  awful.key({ modkey }, "e", function () awful.spawn(filemanager) end,
  { description = "launch filemanager", group = "launcher" }),

  awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
  { description = "select previous", group = "layout" }),

  awful.key({ }, "Print", function () awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -d") end,
  { description = "capture a screenshot", group = "screenshot" }),

  awful.key({"Control" }, "Print", function () awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -w") end,
  { description = "capture a screenshot of active window", group = "screenshot" }),

  awful.key({"Shift" }, "Print", function () awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -s") end,
  { description = "capture a screenshot of selection", group = "screenshot" }),

  awful.key({ modkey, "Control" }, "n",
  function ()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      client.focus = c
      c:raise()
    end
  end,
  { description = "restore minimized", group = "client" }),

  -- Prompt
  awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
  { description = "run prompt", group = "launcher" }),

  awful.key({ modkey }, "ö",
  function ()
    awful.prompt.run {
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
  end,
  { description = "lua execute prompt", group = "awesome" }),

  -- Menubar
  awful.key({ modkey }, "p", function() menubar.show() end,
  { description = "show the menubar", group = "launcher" }),

  awful.key({ modkey, "Shift" }, "y", awful.placement.centered)
)

clientkeys = gears.table.join(
  awful.key({ modkey }, "f",
  function (c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end,
  { description = "toggle fullscreen", group = "client" }),

  awful.key({ modkey }, "x", function (c) c:kill() end,
  { description = "close", group = "client" }),

  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle ,
  { description = "toggle floating", group = "client" }),

  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
  { description = "move to master", group = "client" }),

  awful.key({ modkey }, "o", function (c) c:move_to_screen() end,
  { description = "move to screen", group = "client" }),

  awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
  { description = "toggle keep on top", group = "client" }),

  awful.key({ modkey }, "n",
  function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end ,
  { description = "minimize", group = "client" }),

  awful.key({ modkey }, "m",
  function (c)
    c.maximized = not c.maximized
    c:raise()
  end ,
  { description = "(un)maximize", group = "client" }),

  awful.key({ modkey, "Control" }, "m",
  function (c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end ,
  { description = "(un)maximize vertically", group = "client" }),

  awful.key({ modkey, "Shift" }, "m",
  function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end ,
  { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
    function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end,
    { description = "view tag #"..i, group = "tag" }),

    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
    { description = "move focused client to tag #"..i, group = "tag" })
  )
end

clientbuttons = gears.table.join(
  -- awful.button({ }, 1, function (c) client.focus = c; c:raise()
  -- mymainmenu:hide() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      size_hints_honor = false, -- Remove gaps between terminals
      screen = awful.screen.preferred,
      callback = awful.client.setslave,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
      },
      class = {
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer"
      },

      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        --"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      }
    }, properties = { floating = true }
  },

    -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = { "normal", "dialog" },
      floating = true
    },
    except_any = {
      type = { "normal", "dialog" },
      floating = false
    },
    properties = {
      titlebars_enabled = true
    }
  },
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position and
    not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),

    awful.button({ }, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup {
    layout = wibox.layout.align.horizontal,
    -- Left
    {
      layout = wibox.layout.fixed.horizontal,
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
    },

    -- Middle
    {

      layout = wibox.layout.flex.horizontal,
      -- Title
      {
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
    },

    -- Right
    {
      layout = wibox.layout.fixed.horizontal(),
      awful.titlebar.widget.floatingbutton(c),
      -- awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.closebutton(c),
    },
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and
    awful.client.focus.filter(c) then
    client.focus = c
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
  screen[s]:connect_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do
      -- No borders with only one humanly visible client
      if c.maximized then
        -- NOTE: also handled in focus, but that does not cover maximizing from a
        -- tiled state (when the client had focus).
        c.border_width = 0
      elseif c.floating or layout == "floating" then
        c.border_width = beautiful.border_width
      elseif layout == "max" or layout == "fullscreen" then
        c.border_width = 0
      else
        local tiled = awful.client.tiled(c.screen)
        if #tiled == 1 then -- and c == tiled[1] then
          tiled[1].border_width = 0
          -- if layout ~= "max" and layout ~= "fullscreen" then
          -- XXX: SLOW!
          -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
          -- end
        else
          c.border_width = beautiful.border_width
        end
      end
    end
  end)
end
-- }}}

client.connect_signal("property::floating", function (c)
  if c.floating then
    awful.titlebar.show(c)
  else
    awful.titlebar.hide(c)
  end
end)

local theme = beautiful.get()
beautiful.init(theme)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
