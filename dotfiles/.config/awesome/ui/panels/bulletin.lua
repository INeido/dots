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

local bulletin     = awful.wibar({
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
local function bu_update()
	nbox:emit_signal("widget::redraw_needed")
end

-- Remove every notification
local function reset_notifications()
	scrollbox:reset()
	bu_update()

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
	bu_update()
end

-- Add a notification
function add_notification(n)
	scrollbox:insert(1, notification(n, remove_notification))
	if #scrollbox:get_children() > tonumber(settings.max_entries) then
		scrollbox:remove(#scrollbox:get_children())
	end
	bu_update()
end

function bu_close()
	bulletin.visible = false
end

function bu_open()
	bulletin.visible = true
	naughty.destroy_all_notifications(nil, 1)
end

function bu_toggle()
	if bulletin.visible then
		bu_close()
	else
		bu_open()
	end
end

function bu_get_visibility()
	return bulletin.visible
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

-- ===================================================================
-- Setup
-- ===================================================================

bulletin:setup {
	header(reset_notifications),
	nbox,
	nil,
	layout = wibox.layout.align.vertical,
}

return bulletin
