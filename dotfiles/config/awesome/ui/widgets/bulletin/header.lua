--       ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
--       ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
--       ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║
--       ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
--       ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
--       ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local bin_icon  = ""

-- ===================================================================
-- Widget
-- ===================================================================

local function header(reset_function)
	local bin_widget    = wibox.widget.textbox()
	bin_widget.font     = beautiful.iconfont .. "15"
	bin_widget.markup   = helpers.text_color(bin_icon, beautiful.fg_faded)

	-- The main body of the bulletin
	local header_widget = wibox.widget {
		{
			{
				text   = "Notifications",
				font   = beautiful.font .. "22",
				widget = wibox.widget.textbox,
			},
			nil,
			bin_widget,
			fill_space = true,
			layout     = wibox.layout.align.horizontal,
		},
		margins = dpi(18),
		bottom  = dpi(8),
		widget  = wibox.container.margin,
	}

	-- ===================================================================
	-- Signals
	-- ===================================================================

	bin_widget:connect_signal("mouse::enter", function()
		bin_widget.markup = helpers.text_color(bin_icon, beautiful.fg_normal)
	end)
	bin_widget:connect_signal("mouse::leave", function()
		bin_widget.markup = helpers.text_color(bin_icon, beautiful.fg_faded)
	end)

	-- ===================================================================
	-- Buttons
	-- ===================================================================

	bin_widget:buttons(gears.table.join(
		awful.button({}, 1, function()
			reset_function()
		end)
	))

	return header_widget
end

return header
