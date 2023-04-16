--       ██████╗ █████╗  ██████╗██╗  ██╗███████╗
--      ██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝
--      ██║     ███████║██║     ███████║█████╗
--      ██║     ██╔══██║██║     ██╔══██║██╔══╝
--      ╚██████╗██║  ██║╚██████╗██║  ██║███████╗
--       ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful              = require("awful")
local gears              = require("gears")
local wibox              = require("wibox")
local helpers            = require("helpers")
local beautiful          = require("beautiful")
local dpi                = beautiful.xresources.apply_dpi

cache                    = {}

-- ===================================================================
-- Variables
-- ===================================================================

-- Wallpapers
cache.wallpapers         = helpers.get_wallpapers(false)
cache.wallpapers_blurred = helpers.get_wallpapers(true)

-- Tag Icons
cache.tag_icons          = helpers.get_tag_icons()

-- Powermenu
cache.logout_icon        = gears.surface.load(beautiful.config_path .. "icons/logout.svg")
cache.shutdown_icon      = gears.surface.load(beautiful.config_path .. "icons/power.svg")
cache.reboot_icon        = gears.surface.load(beautiful.config_path .. "icons/reboot.svg")

-- Bar - You can change the icons for your tags here
cache.start_icon         = gears.surface.load(beautiful.config_path .. "icons/arch.svg")
cache.power_icon         = gears.surface.load(beautiful.config_path .. "icons/power.svg")

-- Apps
cache.icon_spotify       = gears.surface.load("/usr/share/icons/" .. beautiful.icon_theme .. "/128x128/apps/spotify.svg")

-- Clients
cache.last_focused_client = {}
