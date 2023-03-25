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
-- Widget
-- ===================================================================

local w = wibox.widget {
    id     = "button",
    text   = "",
    markup = "<span foreground='" .. beautiful.fg_deselected .. "'></span>",
    valign = "center",
    align  = "center",
    font   = beautiful.iconfont_massive,
    widget = wibox.widget.textbox,
}

-- Box the widget
w = helpers.box_pm_widget(w, "sudo reboot", dpi(200), dpi(150))

return w
