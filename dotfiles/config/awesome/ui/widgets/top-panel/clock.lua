--        ██████╗██╗      ██████╗  ██████╗██╗  ██╗
--       ██╔════╝██║     ██╔═══██╗██╔════╝██║ ██╔╝
--       ██║     ██║     ██║   ██║██║     █████╔╝
--       ██║     ██║     ██║   ██║██║     ██╔═██╗
--       ╚██████╗███████╗╚██████╔╝╚██████╗██║  ██╗
--        ╚═════╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝


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
-- Textclock
-- ===================================================================

local clock = wibox.widget.textclock("%H : %M")
clock.font = beautiful.font .. " Bold 10"

-- ===================================================================
-- Icon
-- ===================================================================

local icon = wibox.widget {
    font   = beautiful.iconfont .. " 11",
    markup = helpers.text_color(" ", beautiful.accent),
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w = wibox.widget {
    -- Add margins outside
    {
        icon,
        -- Add Icon
        {
            -- Add Widget
            clock,
            fg = beautiful.text_bright,
            widget = wibox.container.background
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(8),
    right = dpi(8),
    widget = wibox.container.margin,
}

-- Box the widget
w = helpers.box_tp_widget(w, false, 5)

return w
