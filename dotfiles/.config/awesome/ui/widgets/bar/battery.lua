--      ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
--      ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
--      ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝
--      ██╔══██╗██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝
--      ██████╔╝██║  ██║   ██║      ██║   ███████╗██║  ██║   ██║
--      ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local naughty   = require("naughty")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local levels    = { "", "", "", "", "", }

-- ===================================================================
-- Textbox
-- ===================================================================

local battery = wibox.widget.textbox()
battery.font  = beautiful.font .. "11"

-- ===================================================================
-- Icon
-- ===================================================================

local icon    = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color(levels[1] .. " ", beautiful.accent),
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

-- ===================================================================
-- Animation
-- ===================================================================

local timer   = gears.timer({
    timeout = 1, -- Change this to adjust how often the animation updates
    autostart = false,
    callback = function()
        local lvl   = 1
        lvl         = lvl % #levels + 1
        icon.markup = helpers.text_color(levels[lvl] .. " ", beautiful.accent)
    end
})

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w       = wibox.widget {
    -- Add margins outside
    {
        icon,
        -- Add Icon
        {
            -- Add Widget
            battery,
            fg     = beautiful.fg_focus,
            widget = wibox.container.background,
        },
        spacing = dpi(2),
        layout  = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    left   = dpi(8),
    right  = dpi(8),
}

-- Box the widget
w             = helpers.box_ba_widget(w, false, 5)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip = awful.tooltip {
    objects             = { w },
    font                = beautiful.font .. "11",
    mode                = "outside",
    align               = "right",
    preferred_positions = { "right", "left", "bottom" }
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::battery", function(args)
    battery.text = args.percentage .. "%"

    if args.state ~= "charging" then
        timer:stop()

        -- Update icon
        if tonumber(args.percentage) > 80 then
            icon.markup = helpers.text_color(levels[5] .. " ", beautiful.accent)
        elseif tonumber(args.percentage) > 60 then
            icon.markup = helpers.text_color(levels[4] .. " ", beautiful.accent)
        elseif tonumber(args.percentage) > 40 then
            icon.markup = helpers.text_color(levels[3] .. " ", beautiful.accent)
        elseif tonumber(args.percentage) > 20 then
            icon.markup = helpers.text_color(levels[2] .. " ", beautiful.accent)
        else
            icon.markup = helpers.text_color(levels[1] .. " ", beautiful.accent)

            naughty.notification({
                app_name = "Battery Widget",
                title = "Low Battery!",
                text = "Only " .. args.percentage .. "% battery remaining!",
                urgency = "critical",
                timeout = 10,
            })
        end
        tooltip.text = "Not charging."
    else
        timer:start()
        tooltip.text = "Fully charged in " .. args.time_to_full
    end
end)

return w
