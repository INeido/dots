--      ███████╗████████╗ █████╗ ██████╗ ████████╗██╗ ██████╗ ██████╗ ███╗   ██╗
--      ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝██║██╔════╝██╔═══██╗████╗  ██║
--      ███████╗   ██║   ███████║██████╔╝   ██║   ██║██║     ██║   ██║██╔██╗ ██║
--      ╚════██║   ██║   ██╔══██║██╔══██╗   ██║   ██║██║     ██║   ██║██║╚██╗██║
--      ███████║   ██║   ██║  ██║██║  ██║   ██║   ██║╚██████╗╚██████╔╝██║ ╚████║
--      ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        margins = dpi(5),
        {
            widget = wibox.widget.imagebox,
            image = beautiful.start_icon,
        },
    }
}

-- ===================================================================
-- Actions
-- ===================================================================

w:connect_signal("mouse::enter", function()
    w.bg = beautiful.panel_item_hover
end)
w:connect_signal("mouse::leave", function()
    w.bg = beautiful.panel_item_normal
end)

helpers.add_hover_cursor(w, "hand1")

return w
