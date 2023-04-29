--      ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
--      ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
--      ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
--      ██╔══██╗██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
--      ██████╔╝██║  ██║   ██║      ██║   ███████╗██║  ██║   ██║   
--      ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Textbox
-- ===================================================================

local battery = wibox.widget.textbox()
battery.font = beautiful.font .. "11"

-- ===================================================================
-- Icon
-- ===================================================================

local icon = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color(" ", beautiful.accent),
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
            battery,
            fg = beautiful.fg_focus,
            widget = wibox.container.background,
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    left = dpi(8),
    right = dpi(8),
}

-- Box the widget
w = helpers.box_ba_widget(w, false, 5)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip = awful.tooltip {
    objects = { w },
    font = beautiful.font .. "11",
    mode = "outside",
    align = "right",
    preferred_positions = { "right", "left", "bottom" }
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::battery", function(args)
    battery.text = args.percentage
    --tooltip.text = "Total: " .. args.total .. "MB\n" .. "Used: " .. args.used .. "MB\n" .. "Free: " .. args.free .. "MB"
end)

return w
