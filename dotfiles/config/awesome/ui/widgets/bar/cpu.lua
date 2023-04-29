--        ██████╗██████╗ ██╗   ██╗
--       ██╔════╝██╔══██╗██║   ██║
--       ██║     ██████╔╝██║   ██║
--       ██║     ██╔═══╝ ██║   ██║
--       ╚██████╗██║     ╚██████╔╝
--        ╚═════╝╚═╝      ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Texbox
-- ===================================================================

local cpu = wibox.widget.textbox()
cpu.font = beautiful.font .. " 11"

-- ===================================================================
-- Icon
-- ===================================================================

local icon = wibox.widget {
    font   = beautiful.iconfont .. " 11",
    markup = helpers.text_color(" ", beautiful.accent),
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w = wibox.widget {
    -- Margins outside
    {
        icon,
        -- Icon
        {
            -- Widget
            cpu,
            fg = beautiful.fg_focus,
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
w = helpers.box_ba_widget(w, false, 5)

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

awesome.connect_signal("evil::cpu", function(args)
    cpu.text = args.util .. "%"

    local text = ""

    for i = 1, #args.cores do
        text = text .. "Core" .. i - 1 .. ": " .. args.cores[i] .. "%\n"
    end

    text = string.sub(text, 1, -2)

    tooltip.text = text
end)

return w
