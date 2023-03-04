--      ██╗      ██████╗  ██████╗  ██████╗ ██╗   ██╗████████╗
--      ██║     ██╔═══██╗██╔════╝ ██╔═══██╗██║   ██║╚══██╔══╝
--      ██║     ██║   ██║██║  ███╗██║   ██║██║   ██║   ██║   
--      ██║     ██║   ██║██║   ██║██║   ██║██║   ██║   ██║   
--      ███████╗╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝   ██║   
--      ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝    ╚═╝   


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
    font   = beautiful.iconfont_massive,
    text   = "",
    markup = "<span foreground='" .. beautiful.fg_deselected .. "'></span>",
    widget = wibox.widget.textbox,
    valign = "center",
    align  = "center"
}

-- Box the widget
w = helpers.box_pm_widget(w, "logout", dpi(200), dpi(150))

return w
