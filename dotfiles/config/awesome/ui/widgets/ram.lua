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
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Get RAM
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

local w = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        top = dpi(5),
        bottom = dpi(5),
        {
            icon,
            {
                ram,
                fg = beautiful.text_bright,
                widget = wibox.container.background
            },
            spacing = dpi(2),
            layout = wibox.layout.fixed.horizontal
        },
    }
}

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
    ram.text = string.format("%.2f", args.used / 1024) .. "GB"
    tooltip.text = "Total: " .. args.total .. "MB\n" .. "Used: " .. args.used .. "MB\n" .. "Free: " .. args.free .. "MB"
    collectgarbage('collect')
end)

return w
