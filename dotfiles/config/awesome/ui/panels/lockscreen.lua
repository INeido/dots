--      ██╗      ██████╗  ██████╗██╗  ██╗███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗
--      ██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║
--      ██║     ██║   ██║██║     █████╔╝ ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║
--      ██║     ██║   ██║██║     ██╔═██╗ ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║
--      ███████╗╚██████╔╝╚██████╗██║  ██╗███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║
--      ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local has_pam, pam = pcall(require, "liblua_pam")

-- ===================================================================
-- Variables
-- ===================================================================

local characters_entered = 0
local max_displayable_chars = 16

-- ===================================================================
-- Load Widgets
-- ===================================================================

local datetime = require("ui.widgets.lockscreen.datetime")
local input = require("ui.widgets.lockscreen.input")

-- ===================================================================
-- Lockscreen
-- ===================================================================

local lockscreen = wibox({
	visible = false,
	ontop = true,
	type = "splash",
	screen = screen.primary,
	bgimage = cache.wallpapers_blurred[1],
})

awful.placement.maximize(lockscreen)

-- Create the lock screen wibox (extra)
local function create_extender(s)
	local lockscreen_ext
	wibox({
		visible = false,
		ontop = true,
		type = "splash",
		screen = s
	})
	awful.placement.maximize(lockscreen_ext)

	return lockscreen_ext
end

-- Add lockscreen to each screen
awful.screen.connect_for_each_screen(function(s)
	if s.index == 2 then
		s.mylockscreenext = create_extender(2)
		s.mylockscreen = lockscreen
	else
		s.mylockscreen = lockscreen
	end
end)

-- ===================================================================
-- Functions
-- ===================================================================

local function set_visibility(v)
	for s in screen do
		s.mylockscreen.visible = v
		if s.mylockscreenext then
			s.mylockscreenext.visible = v
		end
	end
end

local function reset()
	characters_entered = 0;
	input.change_text("")
end

local function fail()
	characters_entered = 0;
	input.change_text("")
end

local authenticate = function(password)
	if has_pam then
		return pam.auth_current_user(password)
	else
		return password == settings.password
	end
end

local function grab_password()
	awful.prompt.run {
		hooks               = {
			{ {}, 'Escape',
				function(_)
					reset()
					grab_password()
				end
			},
			-- Prevent keygrabber crash
			{ { 'Control' }, 'Delete',
				function()
					reset()
					grab_password()
				end },
			{ { 'Control' }, 's',
				function()
					reset()
					grab_password()
				end },
			{ { 'Control' }, 'r',
				function()
					reset()
					grab_password()
				end },
			{ { 'Control' }, 'g',
				function()
					reset()
					grab_password()
				end },
			{ { 'Control' }, 'c',
				function()
					reset()
					grab_password()
				end },
		},
		keypressed_callback = function(mod, key, cmd)
			if #key == 1 then
				characters_entered = characters_entered + 1
			elseif key == "BackSpace" then
				if characters_entered > 0 then
					characters_entered = characters_entered - 1
				end
			end

			if characters_entered >= max_displayable_chars then
				input.change_text(string.rep(" ", max_displayable_chars))
			else
				input.change_text(string.rep(" ", characters_entered))
			end
		end,
		exe_callback        = function(input)
			if authenticate(input) then
				reset()
				set_visibility(false)
			else
				fail()
				grab_password()
			end
		end,
		textbox             = wibox.widget.textbox(),
	}
end

function ls_show()
	-- You can also trigget the lockscreen from the powermenu, so make sure to close it.
	pm_close()
	set_visibility(true)
	grab_password()
end

-- ===================================================================
-- Signals
-- ===================================================================

-- Update background
tag.connect_signal("property::selected", function(t)
	local selected_tags = awful.screen.focused().selected_tags

	if #selected_tags > 0 then
		lockscreen.bgimage = cache.wallpapers_blurred[selected_tags[1].index]
	else
		lockscreen.bgimage = cache.wallpapers_blurred[1]
	end
end)

-- ===================================================================
-- Setup
-- ===================================================================

lockscreen:setup {
	{
		{
			{
				helpers.vpad(dpi(50)),
				datetime,
				layout = wibox.layout.fixed.vertical,
			},
			layout = wibox.container.place,
		},
		{
			{
				input,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.container.place,
		},
		expand = "none",
		layout = wibox.layout.align.vertical,
	},
	layout = wibox.layout.stack,
}
