--      ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
--      ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
--      ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
--      ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
--      ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
--      ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful                = require("awful")
local gears                = require("gears")
local wibox                = require("wibox")
local beautiful            = require("beautiful")
local dpi                  = beautiful.xresources.apply_dpi

settings                   = {}

-- ===================================================================
-- Variables
-- ===================================================================

-- Password
settings.password          = "root"

-- Apps
settings.terminal          = "alacritty"
settings.browser           = "firefox"
settings.fileexplorer      = "thunar"
settings.editor            = os.getenv("EDITOR") or "nano"

-- Modkeys
settings.modkey            = "Mod4"
settings.altkey            = "Mod1"

-- Greeter text
settings.greeter_text      = "Welcome back"

-- Goodbyer text
settings.goodbyer_text     = "See ya later"

-- Confirmation text
settings.confirmation_text = "Are you sure?"

-- Switches
settings.enable_titlebar   = false

-- Network Interface for the widget
settings.network_interface = "enp42s0"

-- Enter the drives you want to get data from for the widget
settings.drive_names       = { "/", "/Games" }

-- Spotify art temp folder
settings.spotify_temp      = "/tmp"
