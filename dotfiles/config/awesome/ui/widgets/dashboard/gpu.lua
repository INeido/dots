--         ██████╗ ██████╗ ██╗   ██╗
--        ██╔════╝ ██╔══██╗██║   ██║
--        ██║  ███╗██████╔╝██║   ██║
--        ██║   ██║██╔═══╝ ██║   ██║
--        ╚██████╔╝██║     ╚██████╔╝
--         ╚═════╝ ╚═╝      ╚═════╝


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
-- Create Widgets
-- ===================================================================

local create_widget = function(icon, min, max)
    local w = wibox.widget {
        {
            {
                id = "chart",
                min_value = min,
                max_value = max,
                value = 100,
                forced_height = 80,
                forced_width = 80,
                thickness = 10,
                start_angle = math.pi * 1.5,
                rounded_edge = true,
                bg = beautiful.bg_minimize,
                colors = { beautiful.accent },
                widget = wibox.container.arcchart
            },
            {
                markup = "<span foreground='" .. beautiful.accent .. "'>" .. icon .. "</span>",
                valign = "center",
                align  = "center",
                font   = beautiful.iconfont_medium,
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.stack,
        },
        {
            id     = "text",
            align  = "center",
            font   = beautiful.widgetfont,
            widget = wibox.widget.textbox,
        },
        spacing = dpi(10),
        layout = wibox.layout.fixed.vertical,
    }
    return w
end

-- ===================================================================
-- Widget
-- ===================================================================

local util = create_widget("", 0, 100)
local ram = create_widget("", 0, 100)
local temp = create_widget("", 25, 80)

local w = wibox.widget {
    {
        text   = "GPU",
        align  = "center",
        font   = beautiful.dashboardfont_normal,
        widget = wibox.widget.textbox,
    },
    util,
    ram,
    temp,
    spacing = dpi(15),
    layout = wibox.layout.fixed.vertical,
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::gpu", function(args)
    -- Util
    util:get_children_by_id("chart")[1]:set_value(args.util)
    util:get_children_by_id("text")[1]:set_text(args.util .. "%")

    -- RAM
    ram:get_children_by_id("chart")[1]:set_value(args.ram_usage)
    ram:get_children_by_id("text")[1]:set_text(string.format("%.1f", args.ram_used / 1024) .. " GB")

    -- Temp
    temp:get_children_by_id("chart")[1]:set_value(args.temp)
    temp:get_children_by_id("text")[1]:set_text(args.temp .. "°C")

    collectgarbage('collect')
end)

return w
