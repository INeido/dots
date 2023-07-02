--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful   = require("awful")
local helpers = require("helpers")

-- ===================================================================
-- Client Mouse bindings
-- ===================================================================

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button(
            {},
            1,
            function(c)
                c:activate { context = "mouse_click" }
            end),
        awful.button(
            { settings.modkey },
            1,
            function(c)
                c:activate { context = "mouse_click", action = "mouse_move" }
            end),
        awful.button(
            { settings.modkey },
            3,
            function(c)
                c:activate { context = "mouse_click", action = "mouse_resize"}
            end),
    })
end)

-- ===================================================================
-- Client Key bindings
-- ===================================================================

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key(
            { settings.modkey, },
            "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {
                description = "Toggle Fullscreen",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "q",
            function(c)
                c:kill()
            end,
            {
                description = "Close",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, "Control" },
            "space",
            awful.client.floating.toggle,
            {
                description = "Toggle Floating",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "t",
            function(c)
                c.ontop = not c.ontop
            end,
            {
                description = "Toggle keep on top",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "n",
            function(c)
                c.minimized = true
            end,
            {
                description = "Minimize",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            {
                description = "Toggle Maximize",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "1",
            awful.mouse.client.move,
            {
                description = "Move",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "3",
            awful.mouse.client.resize,
            {
                description = "Resize",
                group       = "client"
            }),
        awful.key(
            { settings.modkey, },
            "v",
            function(c)
                local current_screen = c.screen
                local next_screen    = current_screen:get_next_in_direction("right")
                c:move_to_screen(next_screen)
                client.focus = c
                c:raise()
            end,
            {
                description = "Move to next screen",
                group       = "client"
            })
    })
end)

-- ===================================================================
-- Desktop Key bindings
-- ===================================================================

awful.keyboard.append_global_keybindings({
    -- Multimedia
    awful.key(
        {},
        "XF86AudioPlay",
        function()
            awful.util.spawn("playerctl play-pause")
        end,
        {
            description = "Play/Pause Track",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86AudioNext",
        function()
            awful.util.spawn("playerctl next")
        end,
        {
            description = "Play Next Track",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86AudioPrev",
        function()
            awful.util.spawn("playerctl previous")
        end,
        {
            description = "Play Previous Track",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awesome.emit_signal("volume::up")
        end,
        {
            description = "Raise Volume",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awesome.emit_signal("volume::down")
        end,
        {
            description = "Lower Volume",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awesome.emit_signal("volume::mute")
        end,
        {
            description = "Mute Audio",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86AudioMicMute",
        function()
            awesome.emit_signal("mic::mute")
        end,
        {
            description = "Mute Microphone",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86MonBrightnessUp",
        function()
            awesome.emit_signal("brightness::inc")
        end,
        {
            description = "Raise Brightness",
            group       = "multimedia"
        }),
    awful.key(
        {},
        "XF86MonBrightnessDown",
        function()
            awesome.emit_signal("brightness::dec")
        end,
        {
            description = "Lower Brightness",
            group       = "multimedia"
        }),
    awful.key(
        { settings.modkey },
        "v",
        function()
            awesome.emit_signal("brightness::dec")
        end,
        {
            description = "Color Picker",
            group       = "multimedia"
        }),
    -- Panel
    awful.key(
        { settings.modkey },
        "l",
        function()
            awesome.emit_signal("lockscreen::show")
        end,
        {
            description = "Lock screen",
            group       = "panel"
        }),
    awful.key(
        { settings.modkey },
        "p",
        function()
            awesome.emit_signal("powermenu::toggle")
        end,
        {
            description = "Toggle Powermenu",
            group       = "panel"
        }),
    awful.key(
        { settings.modkey, },
        "b",
        function()
            awesome.emit_signal("bulletin::toggle")
        end,
        {
            description = "Toggle Bulletin",
            group       = "panel"
        }),
    awful.key(
        { settings.modkey, },
        "d",
        function()
            awesome.emit_signal("dashboard::toggle")
        end,
        {
            description = "Toggle Dashboard",
            group       = "panel"
        }),
    -- Launcher
    awful.key(
        {},
        "XF86Search",
        function()
            awful.spawn("rofi -show drun -theme ~/.config/rofi/launcher.rasi")
        end,
        {
            description = "Play Previous Track",
            group       = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "space",
        function()
            awful.spawn("rofi -show drun -theme ~/.config/rofi/launcher.rasi")
        end,
        {
            description = "Rofi drun",
            group       = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "c",
        function()
            helpers.get_color()
        end,
        {
            description = "Color Picker",
            group       = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "r",
        function()
            helpers.take_screenshot(false)
        end,
        {
            description = "Screenshot Selection",
            group       = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "t",
        function()
            helpers.take_screenshot(true)
        end,
        {
            description = "Screenshot Screen",
            group       = "launcher"
        }),
    awful.key(
        { settings.modkey, },
        "e",
        function()
            awful.spawn.with_shell(settings.fileexplorer)
        end,
        {
            description = "Start File Explorer",
            group       = "launcher"
        }),
    awful.key(
        { settings.modkey, },
        "Return",
        function()
            awful.spawn(settings.terminal)
        end,
        {
            description = "Open a Terminal",
            group       = "launcher"
        }),
    -- Client
    awful.key(
        { settings.altkey, },
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {
            description = "Go Back",
            group       = "client"
        }),
    -- Layout
    awful.key(
        { settings.modkey, },
        "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        {
            description = "Cycle Forwards",
            group       = "layout"
        }),
    awful.key(
        { settings.modkey, },
        "s",
        function()
            awful.layout.inc(1)
        end,
        {
            description = "Cycle Layouts",
            group       = "layout"
        }),
    awful.key {
        modifiers   = { settings.modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    },
    -- Awesome
    awful.key(
        { settings.modkey, "Control" },
        "r",
        awesome.restart,
        {
            description = "Reload Awesome",
            group       = "awesome"
        }),
    awful.key(
        { settings.modkey, "Shift" },
        "q",
        awesome.quit,
        {
            description = "Quit Awesome",
            group       = "awesome"
        }),
    -- Tag
    awful.key(
        { settings.modkey, },
        "Left",
        awful.tag.viewprev,
        {
            description = "View Previous",
            group       = "tag"
        }),
    awful.key(
        { settings.modkey, },
        "Right",
        awful.tag.viewnext,
        {
            description = "View Next",
            group       = "tag"
        }),
    awful.key(
        { settings.modkey, },
        "Escape",
        awful.tag.history.restore,
        {
            description = "Go Back",
            group       = "tag"
        }),
    awful.key {
        modifiers   = { settings.modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { settings.modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { settings.modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { settings.modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
})
