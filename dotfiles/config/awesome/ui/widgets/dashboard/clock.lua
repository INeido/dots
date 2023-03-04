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

local hours = wibox.widget.textclock()
hours.font = beautiful.dashboardfont_huge
hours.format = "%H"

local minutes = wibox.widget.textclock()
minutes.font = beautiful.dashboardfont_huge
minutes.format = "<span foreground='" .. beautiful.accent .. "'>%M</span>"

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    hours,
    minutes,
    spacing = 8,
    layout = wibox.layout.fixed.horizontal,
}

return w
