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
-- Widgets
-- ===================================================================

local yes = wibox.widget {
    id      = "button",
    text    = "Yes",
    markup  = helpers.text_color("Yes", beautiful.fg_focus),
    valign  = "center",
    align   = "center",
    font    = beautiful.font .. " 24",
    widget  = wibox.widget.textbox,
}

local no = wibox.widget {
    id      = "button",
    text    = "No",
    markup  = helpers.text_color("No", beautiful.fg_focus),
    valign  = "center",
    align   = "center",
    font    = beautiful.font .. " 24",
    widget  = wibox.widget.textbox,
}

-- Box the widgets
yes = helpers.box_pm_widget(yes, dpi(152), dpi(100))
yes.visible = false
no = helpers.box_pm_widget(no, dpi(152), dpi(100))
no.visible = false

return {yes = yes, no = no}
