--      ██████╗  █████╗ ███╗   ███╗
--      ██╔══██╗██╔══██╗████╗ ████║
--      ██████╔╝███████║██╔████╔██║
--      ██╔══██╗██╔══██║██║╚██╔╝██║
--      ██║  ██║██║  ██║██║ ╚═╝ ██║
--      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝


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
-- Textbox
-- ===================================================================

local ram = wibox.widget.textbox()
ram.font = beautiful.widgetfont

-- ===================================================================
-- Icon
-- ===================================================================

local widget_icon = " "
local icon = wibox.widget {
    font   = beautiful.iconfont,
    markup = "<span foreground='" .. beautiful.accent .. "'>" .. widget_icon .. "</span>",
    widget = wibox.widget.textbox,
    valign = "center",
    align  = "center"
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
            ram,
            fg = beautiful.text_bright,
            widget = wibox.container.background
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    left = dpi(8),
    right = dpi(8),
}

-- Box the widget
w = helpers.box_tp_widget(w)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip = awful.tooltip {
    objects = { w },
    mode = "outside",
    align = "right",
    preferred_positions = { "right", "left", "bottom" }
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::ram", function(args)
    ram.text = string.format("%.1f", args.used / 1024) .. "GB"
    tooltip.text = "Total: " .. args.total .. "MB\n" .. "Used: " .. args.used .. "MB\n" .. "Free: " .. args.free .. "MB"
    collectgarbage('collect')
end)

return w
