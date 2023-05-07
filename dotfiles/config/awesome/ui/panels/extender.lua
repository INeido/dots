--      ███████╗██╗  ██╗████████╗███████╗███╗   ██╗██████╗ ███████╗██████╗
--      ██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝████╗  ██║██╔══██╗██╔════╝██╔══██╗
--      █████╗   ╚███╔╝    ██║   █████╗  ██╔██╗ ██║██║  ██║█████╗  ██████╔╝
--      ██╔══╝   ██╔██╗    ██║   ██╔══╝  ██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗
--      ███████╗██╔╝ ██╗   ██║   ███████╗██║ ╚████║██████╔╝███████╗██║  ██║
--      ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful   = require("awful")
local wibox   = require("wibox")
local helpers = require("helpers")

-- ===================================================================
-- Variables
-- ===================================================================

local extenders     = {}

-- ===================================================================
-- Panels
-- ===================================================================

-- Creates blank extenders for the fullscreen panels
awful.screen.connect_for_each_screen(function(s)
	-- Skip primary
	if s ~= screen.primary then
		-- Create panel
		local extender = wibox({
			visible = false,
			ontop = true,
			type = "splash",
			screen = s,
			bgimage = cache.wallpapers[screen.primary.index][1].blurred,
		})

		awful.placement.maximize(extender)

		table.insert(extenders, extender)
	end
end)

-- ===================================================================
-- Functions
-- ===================================================================

function ex_close()
	for i, panel in ipairs(extenders) do
		panel.visible = false
	end
end

function ex_open()
	for i, panel in ipairs(extenders) do
		panel.visible = true
	end
end

function ex_toggle()
	if #extenders ~= 0 then
		if extenders[1].visible then
			ex_close()
		else
			ex_open()
		end
	end
end

-- ===================================================================
-- Signals
-- ===================================================================

-- Update background
tag.connect_signal("property::selected", function(t)
	for i, panel in ipairs(extenders) do
		helpers.update_background(panel, t)
	end
end)
