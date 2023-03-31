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
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keys = {}

-- ===================================================================
-- Mouse bindings
-- ===================================================================

keys.clientbuttons = gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
    awful.button(
        { beautiful.modkey },
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
    awful.button(
        { beautiful.modkey },
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
)

-- ===================================================================
-- Desktop Key bindings
-- ===================================================================

keys.globalkeys = gears.table.join(
    awful.key(
        {},
        "XF86AudioPlay",
        function()
            awful.util.spawn("playerctl play-pause")
        end,
        {
            description = "Play/Pause Track",
            group = "Multimedia"
        }),
    awful.key(
        {},
        "XF86AudioNext",
        function()
            awful.util.spawn("playerctl next")
        end,
        {
            description = "Play Next Track",
            group = "Multimedia"
        }),
    awful.key(
        {},
        "XF86AudioPrev",
        function()
            awful.util.spawn("playerctl previous")
        end,
        {
            description = "Play Previous Track",
            group = "Multimedia"
        }),
    awful.key(
        { beautiful.modkey },
        "space",
        function()
            awful.spawn("rofi -show drun -theme ~/.config/rofi/launcher.rasi")
        end,
        {
            description = "Rofi drun",
            group = "launcher"
        }),
    awful.key(
        { beautiful.modkey },
        "r",
        function()
            awful.spawn.easy_async_with_shell("file=$(mktemp -t screenshot_XXXXXX.png) && maim -suBo \"$file\" && xclip -selection clipboard -t image/png < \"$file\" && mv \"$file\" ~/Pictures/$(date +%s).png")
        end,
        {
            description = "Screenshot Selection",
            group = "launcher"
        }),

    awful.key(
        { beautiful.modkey },
        "t",
        function()
            awful.spawn.easy_async_with_shell("file=$(mktemp -t screenshot_XXXXXX.png) && maim -uBo \"$file\" && xclip -selection clipboard -t image/png < \"$file\" && mv \"$file\" ~/Pictures/$(date +%s).png")
        end,
        {
            description = "Screenshot Screen",
            group = "launcher"
        }),
    awful.key(
        { beautiful.modkey },
        "p",
        function()
            awesome.emit_signal("pm::toggle", nil)
        end,
        {
            description = "Toggle Powermenu",
            group = "launcher"
        }),

    awful.key(
        { beautiful.modkey, },
        "e",
        function()
            awful.spawn.with_shell(beautiful.fileexplorer)
        end,
        {
            description = "Start File Explorer",
            group = "launcher"
        }),
    awful.key(
        { beautiful.modkey, },
        "d",
        function()
            awesome.emit_signal("db::open", nil)
        end,
        {
            description = "Toggle Dashboard",
            group = "launcher"
        }),
    awful.key(
        { beautiful.modkey, },
        "Left",
        awful.tag.viewprev,
        {
            description = "View Previous",
            group = "tag"
        }),
    awful.key(
        { beautiful.modkey, },
        "Right",
        awful.tag.viewnext,
        {
            description = "View Next",
            group = "tag"
        }),
    awful.key(
        { beautiful.modkey, },
        "Escape",
        awful.tag.history.restore,
        {
            description = "Go Back",
            group = "tag"
        }),
    awful.key(
        { beautiful.altkey, },
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {
            description = "Go Back",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        {
            description = "Cycle Forwards",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "s",
        function()
            awful.layout.inc(1)
        end,
        {
            description = "Cycle Layouts",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "Return",
        function()
            awful.spawn(beautiful.terminal)
        end,
        {
            description = "Open a Terminal",
            group = "launcher"
        }),
    awful.key(
        { beautiful.modkey, "Control" },
        "r",
        awesome.restart,
        {
            description = "Reload Awesome",
            group = "awesome"
        }),
    awful.key(
        { beautiful.modkey, "Shift" },
        "q",
        awesome.quit,
        {
            description = "Quit Awesome",
            group = "awesome"
        })
)

-- ===================================================================
-- Client Key bindings
-- ===================================================================

keys.clientkeys = gears.table.join(
    awful.key(
        { beautiful.modkey, },
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {
            description = "Toggle Fullscreen",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "q",
        function(c)
            c:kill()
        end,
        {
            description = "Close",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        {
            description = "Toggle Floating",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {
            description = "Toggle keep on top",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "n",
        function(c)
            c.minimized = true
        end,
        {
            description = "Minimize",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {
            description = "Toggle Maximize",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "1",
        awful.mouse.client.move,
        {
            description = "Move",
            group = "client"
        }),
    awful.key(
        { beautiful.modkey, },
        "3",
        awful.mouse.client.resize,
        {
            description = "Resize",
            group = "client"
        })
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ beautiful.modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "View tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ beautiful.modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "Move focused client to tag #" .. i, group = "tag" })
    )
end

root.keys(keys.globalkeys)

return keys
