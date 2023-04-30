--      ████████╗ █████╗  ██████╗ ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝ ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚══════╝   ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")

-- ===================================================================
-- Systray
-- ===================================================================

-- Create and size systray
local systray   = wibox.widget.systray()
systray:set_base_size(beautiful.systray_icon_size)

-- Create the widget
local w = wibox.widget {
    systray,
    layout = wibox.layout.fixed.horizontal,
}

-- Box the widget
w = helpers.box_ba_widget(w, false, 5, beautiful.bg_normal)

return w
