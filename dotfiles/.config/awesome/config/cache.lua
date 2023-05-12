--       ██████╗ █████╗  ██████╗██╗  ██╗███████╗
--      ██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝
--      ██║     ███████║██║     ███████║█████╗
--      ██║     ██╔══██║██║     ██╔══██║██╔══╝
--      ╚██████╗██║  ██║╚██████╗██║  ██║███████╗
--       ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local gears               = require("gears")
local helpers             = require("helpers")
local beautiful           = require("beautiful")

cache                     = {}

-- ===================================================================
-- Variables
-- ===================================================================

-- List of focused clients
cache.client_focus        = {}
cache.client_focus_lost   = {}

-- Client Icons
cache.client_icons        = {}

-- Wallpapers
cache.wallpapers          = helpers.load_wallpapers()

-- Tag Icons
cache.tag_icons           = helpers.load_tag_icons()

-- Powermenu Icons
cache.logout_icon         = gears.surface.load(beautiful.config_path .. "icons/logout.svg")
cache.shutdown_icon       = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.reboot_icon         = gears.surface.load(beautiful.config_path .. "icons/reboot.svg")

-- Bar Icons
cache.start_icon          = gears.surface.load(beautiful.config_path .. "icons/arch.svg")
cache.power_icon          = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.bulletin_icon       = gears.surface.load(beautiful.config_path .. "icons/notification.svg")

-- App Icons
cache.square_icon         = gears.surface.load(beautiful.config_path .. "icons/square.svg")
cache.colorpicker_icon    = gears.surface.load(beautiful.config_path .. "icons/colorpicker.svg")
cache.screenshot_icon     = gears.surface.load(beautiful.config_path .. "icons/screenshot.svg")
cache.battery_icon     = gears.surface.load(beautiful.config_path .. "icons/battery.svg")

-- Clients
cache.last_focused_client = {}
