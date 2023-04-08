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
        { settings.modkey },
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
    awful.button(
        { settings.modkey },
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
        { settings.modkey },
        "l",
        function()
            ls_show()
        end,
        {
            description = "Lock screen",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "space",
        function()
            awful.spawn("rofi -show drun -theme ~/.config/rofi/launcher.rasi")
        end,
        {
            description = "Rofi drun",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "r",
        function()
            awful.spawn.easy_async_with_shell(
            "file=$(mktemp -t screenshot_XXXXXX.png) && maim -suBo \"$file\" && xclip -selection clipboard -t image/png < \"$file\" && mv \"$file\" ~/Pictures/$(date +%s).png")
        end,
        {
            description = "Screenshot Selection",
            group = "launcher"
        }),

    awful.key(
        { settings.modkey },
        "t",
        function()
            awful.spawn.easy_async_with_shell(
            "file=$(mktemp -t screenshot_XXXXXX.png) && maim -uBo \"$file\" && xclip -selection clipboard -t image/png < \"$file\" && mv \"$file\" ~/Pictures/$(date +%s).png")
        end,
        {
            description = "Screenshot Screen",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey },
        "p",
        function()
            pm_open()
        end,
        {
            description = "Toggle Powermenu",
            group = "launcher"
        }),

    awful.key(
        { settings.modkey, },
        "e",
        function()
            awful.spawn.with_shell(settings.fileexplorer)
        end,
        {
            description = "Start File Explorer",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey, },
        "e",
        function()
            awful.spawn.with_shell(settings.fileexplorer)
        end,
        {
            description = "Start File Explorer",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey, },
        "d",
        function()
            db_open()
        end,
        {
            description = "Toggle Dashboard",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey, },
        "Left",
        awful.tag.viewprev,
        {
            description = "View Previous",
            group = "tag"
        }),
    awful.key(
        { settings.modkey, },
        "Right",
        awful.tag.viewnext,
        {
            description = "View Next",
            group = "tag"
        }),
    awful.key(
        { settings.modkey, },
        "Escape",
        awful.tag.history.restore,
        {
            description = "Go Back",
            group = "tag"
        }),
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
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
        "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        {
            description = "Cycle Forwards",
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
        "s",
        function()
            awful.layout.inc(1)
        end,
        {
            description = "Cycle Layouts",
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
        "Return",
        function()
            awful.spawn(settings.terminal)
        end,
        {
            description = "Open a Terminal",
            group = "launcher"
        }),
    awful.key(
        { settings.modkey, "Control" },
        "r",
        awesome.restart,
        {
            description = "Reload Awesome",
            group = "awesome"
        }),
    awful.key(
        { settings.modkey, "Shift" },
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
        { settings.modkey, },
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
        { settings.modkey, },
        "q",
        function(c)
            c:kill()
        end,
        {
            description = "Close",
            group = "client"
        }),
    awful.key(
        { settings.modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        {
            description = "Toggle Floating",
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {
            description = "Toggle keep on top",
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
        "n",
        function(c)
            c.minimized = true
        end,
        {
            description = "Minimize",
            group = "client"
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
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
        "1",
        awful.mouse.client.move,
        {
            description = "Move",
            group = "client"
        }),
    awful.key(
        { settings.modkey, },
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
        awful.key({ settings.modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "View tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ settings.modkey, "Shift" }, "#" .. i + 9,
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
