--        ██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
--        ██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
--        ██║██╔██╗ ██║██████╔╝██║   ██║   ██║
--        ██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║
--        ██║██║ ╚████║██║     ╚██████╔╝   ██║
--        ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local icon      = ""

-- ===================================================================
-- Date & Time
-- ===================================================================

local lock      = wibox.widget {
	font   = beautiful.iconfont .. "14",
	markup = helpers.text_color(icon, beautiful.fg_normal),
	align  = "center",
	valign = "center",
	widget = wibox.widget.textbox,
}

local input     = wibox.widget {
	font   = beautiful.iconfont .. "11",
	markup = helpers.text_color("", beautiful.fg_normal),
	align  = "center",
	widget = wibox.widget.textbox,
}

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w         = wibox.widget {
	-- Input box widget
	{
		input,
		forced_width  = dpi(320),
		forced_height = dpi(40),
		bg            = beautiful.bg_normal .. "AA",
		widget        = wibox.container.background,
	},
	-- Spacer
	{
		margins = dpi(5),
		widget  = wibox.container.margin,
	},
	-- Lock symbol widget
	{
		lock,
		forced_width  = dpi(50),
		forced_height = dpi(40),
		bg            = beautiful.bg_normal .. "AA",
		widget        = wibox.container.background,
	},
	layout = wibox.layout.align.horizontal,
}

-- ===================================================================
-- Functions
-- ===================================================================

function w.change_text(text)
	input.markup = helpers.text_color(text, beautiful.fg_normal)
end

return w
