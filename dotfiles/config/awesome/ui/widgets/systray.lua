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

local systray = wibox.widget.systray()
systray:set_base_size(dpi(26))

local w = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        margins = dpi(5),
        {
            systray,
            layout = wibox.layout.fixed.horizontal,
        },
    },
}

return w
