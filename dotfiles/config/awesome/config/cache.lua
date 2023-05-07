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

-- Powermenu
cache.logout_icon         = gears.surface.load(beautiful.config_path .. "icons/logout.svg")
cache.shutdown_icon       = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.reboot_icon         = gears.surface.load(beautiful.config_path .. "icons/reboot.svg")

-- Bar - You can change the icons for your tags here
cache.start_icon          = gears.surface.load(beautiful.config_path .. "icons/arch.svg")
cache.power_icon          = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.bulletin_icon       = gears.surface.load(beautiful.config_path .. "icons/notification.svg")

cache.square_icon         = gears.surface.load(beautiful.config_path .. "icons/square.svg")

-- Clients
cache.last_focused_client = {}
