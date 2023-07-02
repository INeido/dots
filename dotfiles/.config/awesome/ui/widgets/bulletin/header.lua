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

local bin_icon      = ""
local mute_off_icon = ""
local mute_on_icon  = ""
local mute_cur_icon = settings.do_not_disturb and mute_on_icon or mute_off_icon

-- ===================================================================
-- Widget
-- ===================================================================

local function header(reset_function)
	local bin_widget    = wibox.widget.textbox()
	bin_widget.font     = beautiful.iconfont .. "15"
	bin_widget.markup   = helpers.text_color(bin_icon, beautiful.fg_faded)

	local mute_widget   = wibox.widget.textbox()
	mute_widget.font    = beautiful.iconfont .. "15"
	mute_widget.markup  = helpers.text_color(mute_cur_icon, beautiful.fg_faded)

	-- The main body of the bulletin
	local header_widget = wibox.widget {
		{
			{
				text   = "Notifications",
				font   = beautiful.font .. "22",
				widget = wibox.widget.textbox,
			},
			nil,
			{
				mute_widget,
				bin_widget,
				spacing    = dpi(20),
				layout     = wibox.layout.fixed.horizontal,
			},
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

	mute_widget:connect_signal("mouse::enter", function()
		mute_widget.markup = helpers.text_color(mute_cur_icon, beautiful.fg_normal)
	end)
	mute_widget:connect_signal("mouse::leave", function()
		mute_widget.markup = helpers.text_color(mute_cur_icon, beautiful.fg_faded)
	end)

	-- ===================================================================
	-- Functions
	-- ===================================================================

	local function toggle_mute()
		settings.do_not_disturb = not settings.do_not_disturb
		mute_cur_icon = settings.do_not_disturb and mute_on_icon or mute_off_icon
		mute_widget.markup = helpers.text_color(mute_cur_icon, beautiful.fg_normal)
	end

	-- ===================================================================
	-- Buttons
	-- ===================================================================

	bin_widget:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			reset_function()
		end)
	))

	mute_widget:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			toggle_mute()
		end)
	))

	return header_widget
end

return header
