--      ██╗      ██████╗  ██████╗██╗  ██╗███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗
--      ██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║
--      ██║     ██║   ██║██║     █████╔╝ ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║
--      ██║     ██║   ██║██║     ██╔═██╗ ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║
--      ███████╗╚██████╔╝╚██████╗██║  ██╗███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║
--      ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful         = require("awful")
local wibox         = require("wibox")
local helpers       = require("helpers")
local beautiful     = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi

-- (Credit @RMTT)
local has_pam, pam  = pcall(require, "liblua_pam")

-- ===================================================================
-- Variables
-- ===================================================================

local chars_entered = 0
local max_chars     = 16

-- ===================================================================
-- Load Widgets
-- ===================================================================

local datetime      = require("ui.widgets.lockscreen.datetime")
local input         = require("ui.widgets.lockscreen.input")

-- ===================================================================
-- Lockscreen
-- ===================================================================

local lockscreen    = wibox({
	visible = false,
	ontop   = true,
	type    = "splash",
	screen  = screen.primary,
	bgimage = cache.wallpapers[screen.primary.index][1].blurred,
})

awful.placement.maximize(lockscreen)

-- ===================================================================
-- Functions
-- ===================================================================

local function set_visibility(v)
	lockscreen.visible = v
end

local function reset()
	chars_entered = 0;
	input.change_text("")
end

local function fail()
	chars_entered = 0;
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
				chars_entered = chars_entered + 1
			elseif key == "BackSpace" then
				if chars_entered > 0 then
					chars_entered = chars_entered - 1
				end
			end

			if chars_entered >= max_chars then
				input.change_text(string.rep(" ", max_chars))
			else
				input.change_text(string.rep(" ", chars_entered))
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
	helpers.update_background(lockscreen, t)
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

-- Show lockscreen after creation
ls_show()
