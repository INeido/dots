--       ██████╗  ██████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███████╗██████╗
--       ██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
--       ██║  ███╗██║   ██║██║   ██║██║  ██║██████╔╝ ╚████╔╝ █████╗  ██████╔╝
--       ██║   ██║██║   ██║██║   ██║██║  ██║██╔══██╗  ╚██╔╝  ██╔══╝  ██╔══██╗
--       ╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝██████╔╝   ██║   ███████╗██║  ██║
--        ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝

-- What's the opposite of a "greeter"?

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

-- Create the widget
local w = wibox.widget {
    {
        {
            {
                markup = "<span foreground='" .. beautiful.fg_focus .. "'>See ya later</span>",
                font   = beautiful.dashboardfont_big,
                valign = "center",
                align  = "center",
                widget = wibox.widget.textbox,
            },
            top = dpi(20),
            bottom = dpi(20),
            left = dpi(20),
            right = dpi(20),
            widget = wibox.container.margin,
        },
        bg = beautiful.panel_item_normal .. "40",
        shape = gears.shape.rect,
        widget = wibox.container.background,
    },
    margins = beautiful.useless_gap,
    widget = wibox.container.margin,
}

return w
