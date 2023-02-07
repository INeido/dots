--      ████████╗ █████╗  ██████╗ ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝ ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚══════╝   ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Systray
-- ===================================================================

local w = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        margins = dpi(5),
        {
            wibox.widget.systray(),
            layout = wibox.layout.fixed.horizontal,
        },
    },
}

return w
