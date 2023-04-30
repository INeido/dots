--       ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--       ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--       ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
--       ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
--       ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--       ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")

-- ===================================================================
-- Widget
-- ===================================================================

local w         = wibox.widget.textbox()
w.font          = beautiful.font .. "Bold 18"

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::network", function(args)
  w.markup = string.format(
    "<span foreground='" .. beautiful.accent .. "'>↓</span> %s <span foreground='" ..
    beautiful.accent .. "'>↑</span> %s", helpers.format_traffic(args.down), helpers.format_traffic(args.up))
end)

return w
