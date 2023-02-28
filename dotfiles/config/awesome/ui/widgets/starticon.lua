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
    image = beautiful.start_icon,
    widget = wibox.widget.imagebox,
}

-- Box the widget
w = helpers.box_tp_widget(w)

-- ===================================================================
-- Actions
-- ===================================================================

w:connect_signal("mouse::enter", function()
    w.bg = beautiful.panel_item_hover
end)
w:connect_signal("mouse::leave", function()
    w.bg = beautiful.panel_item_normal
end)

w:buttons(gears.table.join(
    awful.button({}, 1, function()
        awesome.emit_signal("db::toggle", nil)
    end)
))

helpers.add_hover_cursor(w, "hand1")

return w
