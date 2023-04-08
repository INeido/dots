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
