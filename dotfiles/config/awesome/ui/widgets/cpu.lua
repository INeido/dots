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
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Get CPU
-- ===================================================================

local cpu = wibox.widget.textbox()
cpu.font = beautiful.widgetfont

awesome.connect_signal("evil::cpu", function(args)
    cpu.text = args.avg
    collectgarbage('collect')
end)

-- ===================================================================
-- Icon
-- ===================================================================

local widget_icon = " "
local icon = wibox.widget {
    font   = beautiful.iconfont,
    markup = "<span foreground='" .. beautiful.scheme .. "'>" .. widget_icon .. "</span>",
    widget = wibox.widget.textbox,
    valign = "center",
    align  = "center"
}

-- ===================================================================
-- Widget
-- ===================================================================

return wibox.widget {
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
            wibox.widget {
                cpu,
                fg = beautiful.text_bright,
                widget = wibox.container.background
            },
            spacing = dpi(2),
            layout = wibox.layout.fixed.horizontal
        },
    }
}
