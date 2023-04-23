--      ███████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██╗     ███████╗
--      ██╔════╝██║██╔════╝ ████╗  ██║██╔══██╗██║     ██╔════╝
--      ███████╗██║██║  ███╗██╔██╗ ██║███████║██║     ███████╗
--      ╚════██║██║██║   ██║██║╚██╗██║██╔══██║██║     ╚════██║
--      ███████║██║╚██████╔╝██║ ╚████║██║  ██║███████╗███████║
--      ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

-- ===================================================================
-- Signals
-- ===================================================================

-- Fix, for when your monitor turns off and loses its settings
screen.connect_signal("list", function()
    awful.spawn.with_shell(settings.display)
end)

-- Client decorations
client.connect_signal("request::titlebars", function(c) add_decorations(c) end)

-- Client border color
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Enable sloppy focus, so that focus follows mouse
if settings.sloppy_focus == true then
    client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end)
end

-- Prevent clients from going offscreen
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)
