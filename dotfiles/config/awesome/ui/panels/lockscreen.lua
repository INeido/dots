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
	bgimage = cache.wallpapers.blurred[1],
})

awful.placement.maximize(lockscreen)

local lockscreen_extenders = helpers.extend_to_screens()

-- ===================================================================
-- Functions
-- ===================================================================

local function set_visibility(v)
	lockscreen.visible = v
	for i, panel in ipairs(lockscreen_extenders) do
		panel.visible = v
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
	local selected_tags = lockscreen.screen.selected_tags

	if #selected_tags > 0 then
		lockscreen.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[selected_tags[1].index], lockscreen.screen)
	else
		lockscreen.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[1], lockscreen.screen)
	end

	for i, panel in ipairs(lockscreen_extenders) do
		selected_tags = panel.screen.selected_tags

		if #selected_tags > 0 then
			panel.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[selected_tags[1].index], panel.screen)
		else
			panel.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[1], panel.screen)
		end
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
