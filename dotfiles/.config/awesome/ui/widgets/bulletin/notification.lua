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
local naughty   = require("naughty")
local wibox     = require("wibox")
local awful     = require("awful")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Functions
-- ===================================================================

local function create_embed(link, bg, fg, border, callback)
	helpers.get_website_metadata(link, function(title, description)
		-- Handle error
		if title == nil or description == nil then
			callback(nil)
			return
		end

		-- Handle title and desc here
		local title_widget        = wibox.widget.textbox()
		title_widget.markup       = helpers.text_color(title, fg)
		title_widget.font         = beautiful.font .. "Bold 12"

		local description_widget  = wibox.widget.textbox()
		description_widget.markup = helpers.text_color(description, fg)
		description_widget.font   = beautiful.font .. "11"

		-- Create a layout for the widget
		local w                   = wibox.widget {
			{
				{
					title_widget,
					{
						description_widget,
						strategy = "max",
						height = dpi(40),
						widget = wibox.container.constraint,
					},
					spacing = dpi(5),
					layout  = wibox.layout.fixed.vertical,
				},
				margins = dpi(15),
				widget  = wibox.container.margin,
			},
			bg           = bg,
			border_color = border,
			border_width = dpi(1),
			widget       = wibox.container.background,
		}

		-- ===================================================================
		-- Buttons
		-- ===================================================================

		title_widget:buttons(gears.table.join(
			awful.button({}, 1, nil, function()
				-- Make this prio over other thing
				awful.spawn("xdg-open " .. link)
			end)
		))

		-- ===================================================================
		-- Signals
		-- ===================================================================

		title_widget:connect_signal("mouse::enter", function()
			title_widget.markup = helpers.text_color(title, fg, true)
		end)

		title_widget:connect_signal("mouse::leave", function()
			title_widget.markup = helpers.text_color(title, fg)
		end)

		w:connect_signal("mouse::enter", function()
			w.bg = bg .. "AA"
			--w.border_color = "#00B0F0"
		end)

		w:connect_signal("mouse::leave", function()
			w.bg = bg
			--w.border_color = border
		end)

		callback(w)
	end)
end

-- ===================================================================
-- Widget
-- ===================================================================

local function create_notification(n, close_function)
	-- Extract links from notification text
	local links         = helpers.extract_link(n.text)
	local embed_spacing = dpi(12)
	if #links < 1 then
		embed_spacing = dpi(0)
	end
	local action_spacing = dpi(12)
	if #n.actions < 1 then
		action_spacing = dpi(0)
	end

	local embeds          = wibox.widget {
		spacing = dpi(10),
		layout  = wibox.layout.fixed.vertical,
	}

	-- Get timestamps
	local start_time      = helpers.return_date_time("%H:%M:%S")
	local exact_time      = helpers.return_date_time("%I:%M %p")
	local exact_date_time = helpers.return_date_time("%b %d, %I:%M %p")

	local icon_fallback   = gears.color.recolor_image(beautiful.config_path .. "icons/bell.svg", beautiful.fg_normal)
	local icon_widget     = wibox.widget.imagebox(n.icon)
	if n.icon ~= nil then
		icon_widget.forced_width = dpi(75)
		icon_widget.forced_height = dpi(75)
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

	local app_name_widget  = wibox.widget.textbox()
	app_name_widget.markup = helpers.text_color(app_name, fg)
	app_name_widget.font   = beautiful.font .. "Bold 14"

	local time_widget      = wibox.widget.textbox()
	time_widget.font       = beautiful.font .. "11"

	gears.timer {
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = function()
			local time_diff = tonumber(helpers.get_time_diff(start_time))

			-- Under 1 min
			if time_diff < 60 then
				time_widget:set_markup("now")
				-- Over 1 min but under 1 hour
			elseif time_diff >= 60 and time_diff < 3600 then
				local time_in_minutes = math.floor(time_diff / 60)
				time_widget:set_markup(time_in_minutes .. "m ago")
				-- Over 1 hour but under 1 day
			elseif time_diff >= 3600 and time_diff < 86400 then
				time_widget:set_markup(exact_time)
				-- Over 1 day
			elseif time_diff >= 86400 then
				time_widget:set_markup(exact_date_time)
				return false
			end

			collectgarbage("collect")
		end
	}

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

	-- Create a layout for the widget
	local notification = wibox.widget {
		{
			{
				{
					icon_widget,
					{
						{
							{
								{
									app_icon_widget,
									app_name_widget,
									spacing = dpi(5),
									layout = wibox.layout.fixed.horizontal,
								},
								nil,
								time_widget,
								layout = wibox.layout.align.horizontal,
							},
							bottom = dpi(3),
							widget = wibox.container.margin,
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
						layout  = wibox.layout.fixed.vertical,
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
				{
					bottom = embed_spacing,
					widget = wibox.container.margin,
				},
				embeds,
				fill_space = true,
				layout     = wibox.layout.fixed.vertical,
			},
			margins = dpi(15),
			widget  = wibox.container.margin,
		},
		bg           = bg,
		border_color = border,
		border_width = beautiful.border_width,
		--shape        = function(cr, w, h)
		--	gears.shape.rounded_rect(cr, w, h, 5)
		--end,
		widget       = wibox.container.background,
	}

	if settings.create_embeds then
		for i, link in ipairs(links) do
			if i > tonumber(settings.max_embeds) then
				break
			end
			create_embed(link, bg, fg, border, function(widget)
				if embeds then
					embeds:add(widget)
				end
				notification:emit_signal("widget::layout_changed")
			end)
		end
	end

	-- ===================================================================
	-- Buttons
	-- ===================================================================

	notification:buttons(gears.table.join(
		awful.button({}, 1, nil, function()
			helpers.jump_to_client(n.clients[1])
		end),
		awful.button({}, 2, nil, function()
			close_function(notification)
		end)
	))

	-- ===================================================================
	-- Signals
	-- ===================================================================

	notification:connect_signal("mouse::enter", function()
		notification.bg = bg .. "AA"
	end)

	notification:connect_signal("mouse::leave", function()
		notification.bg = bg
	end)

	actions_template:connect_signal("mouse::enter", function()
		actions_template.bg = bg .. "AA"
		--w.border_color = "#00B0F0"
	end)

	actions_template:connect_signal("mouse::leave", function()
		actions_template.bg = bg
		--w.border_color = border
	end)

	return notification
end

return create_notification
