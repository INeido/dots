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
-- Get Clock
-- ===================================================================

local clock = wibox.widget.textclock("%H : %M")
local date = wibox.widget.textclock("%a, %b %d")
clock.font = beautiful.widgetfont

-- ===================================================================
-- Icon
-- ===================================================================

local widget_icon = " "
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
                clock,
                fg     = beautiful.text_bright,
                widget = wibox.container.background
            },
            spacing = dpi(2),
            layout = wibox.layout.fixed.horizontal
        },
    }
}

-- ===================================================================
-- Actions
-- ===================================================================

w:buttons(gears.table.join(w:buttons(), awful.button({}, 1, nil, function()
    if current_widget == clock then
        current_widget = date
    else
        current_widget = date
    end
end)))

helpers.add_hover_cursor(w, "hand1")

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip = awful.tooltip {
    --objects = { w },
    text = "Click me to toggle time/date display.",
    mode = "outside",
    align = "right",
    preferred_positions = { "right", "left", "bottom" }
}

return w
