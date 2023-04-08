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
hours.font = beautiful.font .. "Bold 30"
hours.format = "%H"

local minutes = wibox.widget.textclock()
minutes.font = beautiful.font .. "Bold 30"
minutes.format = helpers.text_color("%M", beautiful.accent)

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
