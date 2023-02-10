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
local beautiful = require("beautiful")
local helpers = require("helpers")
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
    local w = wibox.widget {
            {
                awful.widget.layoutbox(s),
                margins = dpi(5),
                widget = wibox.container.margin,
            },
            bg = beautiful.panel_item_normal,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        }

    w:buttons(buttons)

    w:connect_signal("mouse::enter", function()
        w.bg = beautiful.panel_item_hover
    end)
    w:connect_signal("mouse::leave", function()
        w.bg = beautiful.panel_item_normal
    end)

    helpers.add_hover_cursor(w, "hand1")

    return w
end

return layoutbox
