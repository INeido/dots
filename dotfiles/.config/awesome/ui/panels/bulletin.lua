--      ██████╗ ██╗   ██╗██╗     ██╗     ███████╗████████╗██╗███╗   ██╗
--      ██╔══██╗██║   ██║██║     ██║     ██╔════╝╚══██╔══╝██║████╗  ██║
--      ██████╔╝██║   ██║██║     ██║     █████╗     ██║   ██║██╔██╗ ██║
--      ██╔══██╗██║   ██║██║     ██║     ██╔══╝     ██║   ██║██║╚██╗██║
--      ██████╔╝╚██████╔╝███████╗███████╗███████╗   ██║   ██║██║ ╚████║
--      ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful        = require("awful")
local wibox        = require("wibox")
local helpers      = require("helpers")
local naughty      = require("naughty")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi

-- ===================================================================
-- Widgets
-- ===================================================================

local notification = require("ui.widgets.bulletin.notification")
local header       = require("ui.widgets.bulletin.header")
local scrollbox    = wibox.widget {
	spacing = dpi(20),
	layout  = wibox.layout.fixed.vertical,
}
local nbox         = wibox.widget {
	scrollbox,
	margins = dpi(18),
	widget  = wibox.container.margin,
}

-- ===================================================================
-- Variables
-- ===================================================================

local min_widgets  = 3
local pointer      = 0

-- ===================================================================
-- Wibar
-- ===================================================================

local bulletin     = {}

bulletin.panel     = awful.wibar({
	visible           = false,
	ontop             = true,
	restrict_workarea = false,
	stretch           = false,
	align             = "bottom",
	screen            = screen.primary,
	bg                = beautiful.bg_normal,
	position          = settings.bulletin_location,
	border_width      = beautiful.border_width,
	border_color      = beautiful.border_normal,
	height            = screen.primary.geometry.height - beautiful.bar_height - beautiful.border_width * 2,
	width             = dpi(600),
	maximum_width     = dpi(600),
})

-- ===================================================================
-- Functions
-- ===================================================================

-- Redraw the Notifications
local function update()
	nbox:emit_signal("widget::redraw_needed")
end

local function close()
	bulletin.panel.visible = false
end

local function open()
	bulletin.panel.visible = true
	naughty.destroy_all_notifications(nil, 1)
end

local function toggle()
	if bulletin.panel.visible then
		close()
	else
		open()
	end
end

-- Remove every notification
local function reset_notifications()
	scrollbox:reset()
	update()

	-- Reset scroll
	pointer = 0
end

-- Remove a specific notification
local function remove_notification(n_)
	for i, child in ipairs(scrollbox:get_children()) do
		if child == n_ then
			scrollbox:remove(i)
		end
	end
	update()
end

-- Add a notification
local function add_notification(n)
	scrollbox:insert(1, notification(n, remove_notification))
	if #scrollbox:get_children() > tonumber(settings.max_entries) then
		scrollbox:remove(#scrollbox:get_children())
	end
	update()
end

-- ===================================================================
-- Signals
-- ===================================================================

-- Make the scrollbox actually scrollable (Credit @OlMon)
scrollbox:connect_signal("button::press", function(_, _, _, button)
	if button == 5 then -- up scrolling
		if pointer < #scrollbox.children and ((#scrollbox.children - pointer) >= min_widgets) then
			pointer = pointer + 1
			scrollbox.children[pointer].visible = false
		end
	elseif button == 4 then -- down scrolling
		if pointer > 0 then
			scrollbox.children[pointer].visible = true
			pointer = pointer - 1
		end
	end
end)

naughty.connect_signal("request::display", function(n)
	-- Add destroyed notifications to the bulletin
	n:connect_signal("destroyed", function(self, reason, keep_visible)
		-- Timeout
		if reason == 1 then
			add_notification(n)
			-- User dismissed
		elseif reason == 2 then
			helpers.jump_to_client(n.clients[1])
		end
	end)

	-- Display the notification using the default implementation
	if bulletin.panel.visible == false and not settings.do_not_disturb then
		naughty.layout.box { notification = n, widget_template = require("ui.widgets.bulletin.not_template")(n) }
		naughty.layout.box.buttons = nil
	else
		n:destroy(1)
	end
end)

-- Open bulletin
awesome.connect_signal("bulletin::open", function()
	open()
end)

-- Close bulletin
awesome.connect_signal("bulletin::close", function()
	close()
end)

-- Toggle bulletin
awesome.connect_signal("bulletin::toggle", function()
	toggle()
end)

-- ===================================================================
-- Setup
-- ===================================================================

bulletin.panel:setup {
	header(reset_notifications),
	nbox,
	nil,
	layout = wibox.layout.align.vertical,
}
