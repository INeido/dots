--      ████████╗███████╗███╗   ███╗██████╗
--      ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗
--         ██║   █████╗  ██╔████╔██║██████╔╝
--         ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝
--         ██║   ███████╗██║ ╚═╝ ██║██║
--         ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Get Temp
-- ===================================================================

local temp = wibox.widget.textbox()
temp.font = beautiful.widgetfont

-- ===================================================================
-- Icon
-- ===================================================================

local widget_icon = " "
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
                temp,
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

awesome.connect_signal("evil::temp", function(args)
    temp.text = args.cpu .. "°C" .. " / " .. args.gpu .. "°C"
    tooltip.text = "CPU Temparature: " .. args.cpu .. "°C" .. "\n" .. "GPU Temparature: " .. args.gpu .. "°C"

    collectgarbage('collect')
end)

return w
