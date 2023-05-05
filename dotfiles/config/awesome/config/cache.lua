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

-- Wallpapers
cache.wallpapers          = helpers.load_wallpapers()

-- Tag Icons
cache.tag_icons           = helpers.load_tag_icons()

-- Powermenu
cache.logout_icon         = gears.surface.load(beautiful.config_path .. "icons/logout.svg")
cache.shutdown_icon       = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.reboot_icon         = gears.surface.load(beautiful.config_path .. "icons/reboot.svg")

-- Bar - You can change the icons for your tags here
cache.start_icon          = gears.surface.load(beautiful.config_path .. "icons/arch.svg")
cache.power_icon          = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.bulletin_icon       = gears.surface.load(beautiful.config_path .. "icons/notification.svg")

cache.square_icon         = gears.surface.load(beautiful.config_path .. "icons/square.svg")

-- Apps
cache.icon_spotify        = gears.surface.load("/usr/share/icons/" .. beautiful.icon_theme .. "/128x128/apps/spotify.svg")

-- Clients
cache.last_focused_client = {}
