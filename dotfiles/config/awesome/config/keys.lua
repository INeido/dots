--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")

local hotkeys_popup = require("awful.hotkeys_popup")

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

local keys = {}

-- ===================================================================
-- Mouse bindings
-- ===================================================================

keys.desktopbuttons = gears.table.join(
    awful.button({}, 1,
        function()
            awesome.emit_signal("dashboard::toggle")
        end)
)

keys.clientbuttons = gears.table.join(
    awful.button({}, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
    awful.button({ modkey }, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
    awful.button({ modkey }, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
)

-- ===================================================================
-- Desktop Key bindings
-- ===================================================================

keys.globalkeys = gears.table.join(
-- Multimedia
    awful.key({}, "XF86AudioPlay",
        function()
            awful.util.spawn("playerctl play-pause")
        end,
        { description = "Play/Pause Track", group = "Multimedia" }),
    awful.key({}, "XF86AudioNext",
        function()
            awful.util.spawn("playerctl next")
        end,
        { description = "Play Next Track", group = "Multimedia" }),
    awful.key({}, "XF86AudioPrev",
        function()
            awful.util.spawn("playerctl previous")
        end,
        { description = "Play Previous Track", group = "Multimedia" }),

    -- Custom manipulation
    awful.key({ altkey }, "space",
        function()
            awful.spawn("rofi -show drun")
        end,
        { description = "Show Rofi drun", group = "launcher" }),
    awful.key({ modkey, }, "e",
        function()
            awful.spawn("dolphin")
        end,
        { description = "Start Dolphin", group = "launcher" }),
    awful.key({ modkey, }, "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left",
        awful.tag.viewprev,
        { description = "view previous",
            group = "tag" }),
    awful.key({ modkey, }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }),
    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ altkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return",
        function()
            awful.spawn(terminal)
        end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" })
)

-- ===================================================================
-- Client Key bindings
-- ===================================================================

keys.clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c",
        function(c)
            c:kill()
        end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o",
        function(c)
            c:move_to_screen()
        end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t",
        function(c)
            c.ontop = not c.ontop
        end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
for i = 1, 3 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" })
    )
end

root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

return keys
