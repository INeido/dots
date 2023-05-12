--      ███╗   ██╗ ██████╗ ████████╗  ████████╗███████╗███╗   ███╗██████╗ ██╗      █████╗ ████████╗███████╗
--      ████╗  ██║██╔═══██╗╚══██╔══╝  ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝
--      ██╔██╗ ██║██║   ██║   ██║        ██║   █████╗  ██╔████╔██║██████╔╝██║     ███████║   ██║   █████╗
--      ██║╚██╗██║██║   ██║   ██║        ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝
--      ██║ ╚████║╚██████╔╝   ██║███████╗██║   ███████╗██║ ╚═╝ ██║██║     ███████╗██║  ██║   ██║   ███████╗
--      ╚═╝  ╚═══╝ ╚═════╝    ╚═╝╚══════╝╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local helpers   = require("helpers")
local naughty   = require("naughty")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Widget Template
-- ===================================================================

local function template(n)
	local bg, fg, border
	if n.urgency == "low" then
		bg = "#262627"
		fg = beautiful.fg_normal .. "BB"
		border = beautiful.fg_normal .. "66"
	elseif n.urgency == "normal" then
		bg = "#262627"
		fg = beautiful.fg_normal
		border = beautiful.fg_normal .. "BB"
	elseif n.urgency == "critical" then
		bg = "#262627"
		fg = beautiful.fg_normal
		border = "#BB0000"
	end

	-- Actions Blueprint
	local actions_template = wibox.widget {
		notification    = n,
		base_layout     = wibox.widget {
			spacing = dpi(0),
			layout  = wibox.layout.flex.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							id     = "text_role",
							font   = beautiful.font .. "11",
							widget = wibox.widget.textbox,
						},
						widget = wibox.container.place,
					},
					widget = wibox.container.background,
				},
				bg            = bg,
				border_width  = dpi(1),
				border_color  = border,
				forced_height = dpi(30),
				widget        = wibox.container.background,
			},
			margins = dpi(4),
			widget  = wibox.container.margin,
		},
		style           = { underline_normal = false },
		widget          = naughty.list.actions,
	}

	actions_template:connect_signal("mouse::enter", function()
		actions_template.bg = bg .. "AA"
		--w.border_color = "#00B0F0"
	end)

	actions_template:connect_signal("mouse::leave", function()
		actions_template.bg = bg
		--w.border_color = border
	end)

	local close = wibox.widget {
		{
			{
				font = beautiful.font .. "10",
				text = "✕",
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox
			},
			start_angle = math.pi * 1.5,
			thickness = dpi(2),
			min_value = 0,
			max_value = 360,
			value = 360,
			widget = wibox.container.arcchart,
			id = "arcchart"
		},
		fg = beautiful.fg_normal,
		bg = beautiful.bg_normal,
		widget = wibox.container.background
	}
	local arc = close.arcchart

	local action_spacing = dpi(12)
	if #n.actions < 1 then
		action_spacing = dpi(0)
	end

	-- If no appname is passed it might not be nil but an empty string
	local app_name = nil
	if n.app_name == "" then
		app_name = "System Notification"
	elseif n.app_name ~= nil then
		app_name = helpers.capitalize(n.app_name)
	end

	local app_icon_widget = wibox.widget.imagebox()
	if app_name ~= "System Notification" then
		app_icon_widget.forced_width = dpi(22)
		app_icon_widget.forced_height = dpi(22)

		if app_name == "Color Picker" then
			app_icon_widget.image = cache.colorpicker_icon
		elseif app_name == "Screenshot Tool" then
			app_icon_widget.image = cache.screenshot_icon
		else
			app_icon_widget.image = helpers.find_icon(app_name)
		end
	end

	local icon_widget = wibox.widget.imagebox(n.icon)
	if n.icon ~= nil then
		icon_widget.forced_width = dpi(75)
		icon_widget.forced_height = dpi(75)
	end

	local app_name_widget  = wibox.widget.textbox()
	app_name_widget.markup = helpers.text_color(app_name, fg)
	app_name_widget.font   = beautiful.font .. "Bold 14"

	local w_template       = wibox.widget {
		{
			{
				{
					{
						{
							icon_widget,
							{
								{
									{
										app_icon_widget,
										app_name_widget,
										spacing = dpi(5),
										layout = wibox.layout.fixed.horizontal,
									},
									nil,
									{
										close,
										strategy = "exact",
										width    = dpi(20),
										height   = dpi(20),
										widget   = wibox.container.constraint,
									},
									layout = wibox.layout.align.horizontal,
								},
								{
									markup = helpers.text_color(n.title, fg),
									font   = beautiful.font .. "13",
									align  = "left",
									widget = wibox.widget.textbox,
								},
								{
									{
										markup    = helpers.text_color(n.text, fg),
										font      = beautiful.font .. "12",
										align     = "left",
										ellipsize = "end",
										widget    = wibox.widget.textbox,
									},
									strategy = "max",
									height   = dpi(60),
									widget   = wibox.container.constraint,
								},
								spacing = dpi(5),
								layout = wibox.layout.fixed.vertical,

							},
							spacing    = dpi(8),
							fill_space = true,
							layout     = wibox.layout.fixed.horizontal,
						},
						{
							bottom = action_spacing,
							widget = wibox.container.margin,
						},
						actions_template,
						fill_space = true,
						layout     = wibox.layout.fixed.vertical,
					},
					margins = dpi(15),
					widget  = wibox.container.margin,
				},
				strategy = "min",
				width    = dpi(300),
				widget   = wibox.container.constraint,
			},
			strategy = "max",
			width    = dpi(500),
			widget   = wibox.container.constraint,
		},
		bg           = bg,
		border_color = border,
		border_width = beautiful.border_width,
		widget       = wibox.container.background,
	}

	local timeout          = n.timeout
	local remove_time      = timeout

	if timeout ~= 0 then
		-- Calculate the FPS of the animation
		local increment = 1 / tonumber(settings.arc_animation_fps)

		arc.value = 360
		local arc_timer = gears.timer {
			timeout = increment,
			call_now = true,
			autostart = true,
			callback = function()
				arc.value = (remove_time - 0) / (timeout - 0) * 360
				remove_time = remove_time - increment
			end
		}

		w_template:connect_signal("mouse::enter", function()
			arc_timer:stop()
			n.timeout = 99999
		end)

		w_template:connect_signal("mouse::leave", function()
			arc_timer:start()
			n.timeout = remove_time
		end)
	end

	close:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			n:destroy()
		end),
		awful.button({}, 3, nil, function()
			n:destroy()
		end)
	))

	w_template:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			helpers.jump_to_client(n.clients[1])
		end),
		awful.button({}, 3, nil, function()
			n:destroy()
		end)
	))

	return w_template
end

return template
