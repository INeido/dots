--        ██████╗  █████╗ ████████╗███████╗████████╗██╗███╗   ███╗███████╗
--        ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝╚══██╔══╝██║████╗ ████║██╔════╝
--        ██║  ██║███████║   ██║   █████╗     ██║   ██║██╔████╔██║█████╗
--        ██║  ██║██╔══██║   ██║   ██╔══╝     ██║   ██║██║╚██╔╝██║██╔══╝
--        ██████╔╝██║  ██║   ██║   ███████╗   ██║   ██║██║ ╚═╝ ██║███████╗
--        ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝   ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Date & Time
-- ===================================================================

local time      = wibox.widget.textclock("%H:%M")
time.font       = beautiful.font .. " Bold 50"
time.align      = "center"

local date      = wibox.widget.textclock("%A, %d.%m.%y")
date.font       = beautiful.font .. " Bold 24"

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w         = wibox.widget {
	time,
	date,
	spacing = dpi(10),
	layout  = wibox.layout.fixed.vertical,
}

-- Box the widget
w               = helpers.box_db_widget(w, dpi(400), dpi(200), beautiful.widget_normal .. "88")

return w
