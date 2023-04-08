--        ██████╗  ██████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███████╗██████╗
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
-- Variables
-- ===================================================================

local text = settings.goodbyer_text

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w = wibox.widget {
    -- Outer Margin
    {
        -- Background
        {
            -- Margins
            {
                -- Text
                id = "textbox",
                markup = helpers.text_color(text, beautiful.fg_focus),
                font   = beautiful.font .. "24",
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
        bg = beautiful.panel_item_normal .. "AA",
        shape = gears.shape.rect,
        widget = wibox.container.background,
    },
    margins = beautiful.useless_gap,
    widget = wibox.container.margin,
}

return w
