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
-- Important
-- ===================================================================

-- Password
settings.password          = "root"

-- Display config
settings.display           = "xrandr --output DP-0 --primary --mode 2560x1440 --pos 0x0 --rotate normal --rate 239.97"

-- ===================================================================
-- Look & Feel
-- ===================================================================

-- Layout
settings.bar_location      = "top" -- 'top', 'bottom'

-- Switches
settings.enable_titlebar   = false
settings.sloppy_focus      = false

-- ===================================================================
-- General
-- ===================================================================

-- Apps
settings.terminal          = "alacritty"
settings.browser           = "qutebrowser"
settings.fileexplorer      = "nemo"
settings.editor            = os.getenv("EDITOR") or "nano"

-- Modkeys
settings.modkey            = "Mod4"
settings.altkey            = "Mod1"

-- Paths
settings.wallpaper_save    = beautiful.config_path .. "wallpapers/save/"

-- ===================================================================
-- Widgets
-- ===================================================================

-- Greeter text
settings.greeter_text      = "Welcome back"

-- Goodbyer text
settings.goodbyer_text     = "See ya later"

-- Confirmation text
settings.confirmation_text = "Are you sure?"

-- Network Interface for the widget
settings.network_interface = "enp42s0"

-- Enter the drives you want to get data from for the widget
settings.drive_names       = { "/", "/Games" }

-- Spotify art temp folder
settings.spotify_temp      = "/tmp"
