--      ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--      ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--      ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--      ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--      ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--      ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful                             = require("awful")
local gears                             = require("gears")
local wibox                             = require("wibox")
local helpers                           = require("helpers")
local naughty                           = require("naughty")
local beautiful                         = require("beautiful")
local dpi                               = beautiful.xresources.apply_dpi

-- ===================================================================
-- Presets & Defaults
-- ===================================================================

naughty.config.presets.low.timeout      = 5
naughty.config.presets.normal.timeout   = 6
naughty.config.presets.critical.timeout = 12

naughty.config.defaults.ontop           = true
naughty.config.defaults.icon_size       = dpi(80)
naughty.config.defaults.title           = "System Notification"
naughty.config.defaults.margin          = dpi(10)
naughty.config.defaults.position        = "top_right"
naughty.config.defaults.border_width    = beautiful.border_width
naughty.config.defaults.border_color    = beautiful.border_color
naughty.config.defaults.spacing         = dpi(10)

-- ===================================================================
-- Icon
-- ===================================================================

naughty.connect_signal(
	'request::icon',
	function(n, context, hints)

	end
)

-- ===================================================================
-- Widget Template
-- ===================================================================

naughty.connect_signal(
	"request::display",
	function(n)
		-- Change colors based on urgency

		local action_template_widget = {}

		local actions_template = wibox.widget {
			notification = n,
			base_layout = wibox.widget {
				spacing = dpi(40),
				layout = wibox.layout.fixed.horizontal
			},
			widget_template = action_template_widget,
			style = {
				underline_normal = false,
				underline_selected = true,
				bg_normal = beautiful.border_color,
				bg_selected = beautiful.bg_focus
			},
			widget = naughty.list.actions
		}

		local w_template = wibox.widget {
			{
				{
					{
						{
							{
								{
									{
										{
											{
												{
													image = gears.color.recolor_image(cache.bulletin_icon,
														beautiful.fg_normal),
													resize = false,
													widget = wibox.widget.imagebox
												},
												right = dpi(5),
												widget = wibox.container.margin
											},
											{
												markup = n.app_name or 'System Notification',
												align = "center",
												valign = "center",
												widget = wibox.widget.textbox
											},
											layout = wibox.layout.fixed.horizontal
										},
										fg = beautiful.fg_normal,
										widget = wibox.container.background
									},
									margins = dpi(10),
									widget = wibox.container.margin
								},
								nil,
								{
									{
										{
											text = os.date("%H:%M"),
											widget = wibox.widget.textbox
										},
										id = "background",
										fg = beautiful.fg_normal,
										widget = wibox.container.background
									},
									{
										{
											{
												{
													{
														font = beautiful.font .. "8",
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
													id = "arc_chart"
												},
												id = "background",
												fg = beautiful.fg_normal,
												bg = beautiful.bg_normal,
												widget = wibox.container.background
											},
											strategy = "exact",
											width = dpi(20),
											height = dpi(20),
											widget = wibox.container.constraint,
											id = "const"
										},
										margins = dpi(10),
										widget = wibox.container.margin,
										id = "arc_margin"
									},
									layout = wibox.layout.fixed.horizontal,
									id = "arc_app_layout_2"
								},
								id = "arc_app_layout",
								layout = wibox.layout.align.horizontal
							},
							id = "arc_app_bg",
							border_color = beautiful.border_color,
							border_width = dpi(2),
							widget = wibox.container.background
						},
						{
							{
								{
									{
										{
											image = n.icon,
											resize = true,
											widget = wibox.widget.imagebox,
											clip_shape = function(cr, width, height)
												gears.shape.rounded_rect(cr, width, height, 10)
											end
										},
										width = naughty.config.defaults.icon_size,
										height = naughty.config.defaults.icon_size,
										strategy = "exact",
										widget = wibox.container.constraint
									},
									halign = "center",
									valign = "top",
									widget = wibox.container.place
								},
								left = dpi(20),
								bottom = dpi(15),
								top = dpi(15),
								right = dpi(10),
								widget = wibox.container.margin
							},
							{
								{
									{
										widget = naughty.widget.title,
										align = "left"
									},
									{
										widget = naughty.widget.message,
										align = "left"
									},
									{
										actions_template,
										widget = wibox.container.place
									},
									layout = wibox.layout.fixed.vertical
								},
								left = dpi(10),
								bottom = dpi(10),
								top = dpi(10),
								right = dpi(20),
								widget = wibox.container.margin
							},
							layout = wibox.layout.fixed.horizontal
						},
						id = "widget_layout",
						layout = wibox.layout.fixed.vertical
					},
					id = "min_size",
					strategy = "min",
					width = dpi(200),
					widget = wibox.container.constraint
				},
				id = "max_size",
				strategy = "max",
				width = dpi(500),
				widget = wibox.container.constraint
			},
			id = "background",
			bg = beautiful.bg_normal,
			border_color = beautiful.border_color,
			border_width = beautiful.border_width,
			widget = wibox.container.background
		}

		local close = w_template.max_size.min_size.widget_layout.arc_app_bg.arc_app_layout.arc_app_layout_2.arc_margin
			.const
			.background
		local arc = close.arc_chart

		local timeout = n.timeout
		local remove_time = timeout

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

		-- Any click on the X
		close:connect_signal("button::press", function()
			n:destroy()
		end)

		-- Rightclick on the notification body
		w_template:connect_signal("button::press", function(c, d, e, key)
			if key == 1 then
				helpers.jump_to_client(n.clients[1])
			elseif key == 3 then
				n:destroy()
			end
		end)

		local box = naughty.layout.box {
			notification = n,
			timeout = n.timeout,
			type = "notification",
			screen = awful.screen.focused(),
			widget_template = w_template
		}

		box.buttons = {}
		n.buttons = {}
	end
)
