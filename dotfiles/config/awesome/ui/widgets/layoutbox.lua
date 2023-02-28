--      ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗██████╗  ██████╗ ██╗  ██╗
--      ██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝██╔══██╗██╔═══██╗╚██╗██╔╝
--      ██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║   ██████╔╝██║   ██║ ╚███╔╝
--      ██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║   ██╔══██╗██║   ██║ ██╔██╗
--      ███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║   ██████╔╝╚██████╔╝██╔╝ ██╗
--      ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   ╚═════╝  ╚═════╝ ╚═╝  ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Buttons
-- ===================================================================

local buttons = gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc( -1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end),
    awful.button({}, 5, function() awful.layout.inc( -1) end)
)

-- ===================================================================
-- Layoutbox
-- ===================================================================

local layoutbox = function(s)
    -- Create the widget
    local w = awful.widget.layoutbox(s)

    w:buttons(buttons)

    w:connect_signal("mouse::enter", function()
        w.bg = beautiful.panel_item_hover
    end)
    w:connect_signal("mouse::leave", function()
        w.bg = beautiful.panel_item_normal
    end)

    helpers.add_hover_cursor(w, "hand1")

    -- Box the widget
    w = helpers.box_tp_widget(w)

    return w
end

return layoutbox
