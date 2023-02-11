--      ██████╗ ███████╗ ██████╗ ██████╗ ██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--      ██╔══██╗██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--      ██║  ██║█████╗  ██║     ██║   ██║██████╔╝███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--      ██║  ██║██╔══╝  ██║     ██║   ██║██╔══██╗██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--      ██████╔╝███████╗╚██████╗╚██████╔╝██║  ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--      ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

-- ===================================================================
-- Gather
-- ===================================================================

local add_decorations = function(c)
    -- require("ui.decorations.top")(c)
    -- require("ui.decorations.left")(c)
    -- require("ui.decorations.right")(c)
    -- require("ui.decorations.bottom")(c)

    -- Clean up
    collectgarbage("collect")
end

-- ===================================================================
-- Apply
-- ===================================================================

client.connect_signal("request::titlebars", function(c) add_decorations(c) end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- {{{ Signals
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)
-- }}}