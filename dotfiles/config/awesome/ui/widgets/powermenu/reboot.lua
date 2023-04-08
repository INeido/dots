--      ██████╗ ███████╗██████╗  ██████╗  ██████╗ ████████╗
--      ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝
--      ██████╔╝█████╗  ██████╔╝██║   ██║██║   ██║   ██║
--      ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██║   ██║   ██║
--      ██║  ██║███████╗██████╔╝╚██████╔╝╚██████╔╝   ██║
--      ╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝  ╚═════╝    ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Action
-- ===================================================================

local function action()
    awful.spawn.with_shell("sudo reboot")
end

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    id     = "button",
    text   = "",
    markup = helpers.text_color("", beautiful.fg_focus),
    valign = "center",
    align  = "center",
    font   = beautiful.iconfont .. " 35",
    widget = wibox.widget.textbox,
}

-- Box the widget
w = helpers.box_pm_widget(w, dpi(100), dpi(100))

return {w = w, a = action}
