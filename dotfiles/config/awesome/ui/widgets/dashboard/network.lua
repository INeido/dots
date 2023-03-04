--       ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--       ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--       ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
--       ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
--       ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--       ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Functions
-- ===================================================================

local function format_traffic(value)
  if value > 1024 then
    return string.format("%.2f Mb/s", value / 1024)
  else
    return string.format("%.0f Kb/s", value)
  end
end

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget.textbox()
w.font = beautiful.dashboardfont_small

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::network", function(args)
  w.markup = string.format(
    "<span foreground='" .. beautiful.accent .. "'>↓</span> %s <span foreground='" ..
    beautiful.accent .. "'>↑</span> %s", format_traffic(args.down), format_traffic(args.up))

  collectgarbage('collect')
end)

return w
