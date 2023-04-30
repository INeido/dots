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
local beautiful            = require("beautiful")

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
settings.bar_location      = "top"  -- 'top', 'bottom'
settings.bulletin_location = "left" -- 'left', 'right'

-- Switches
settings.enable_titlebar   = false
settings.sloppy_focus      = false

-- Wallpaper - If any of these change, re-render the wallpaper by deleting wp_hash.txt and restarting Awesome!
settings.wp_fullres        = false -- Can be a performance hit on slow machines
settings.wp_quality        = "80"  -- In percent
settings.wp_blur           = "08"  -- In hex

-- Tags
settings.tags              = {
	{
		layout   = awful.layout.suit.tile,
		selected = true,
	},
	{
		layout = awful.layout.suit.max,
	},
	{
		layout = awful.layout.suit.max,
	},
	{
		layout = awful.layout.suit.floating,
	},
}

-- ===================================================================
-- General
-- ===================================================================

-- Apps
settings.terminal          = "alacritty"
settings.browser           = "qutebrowser"
settings.musicplayer       = "spotify"
settings.fileexplorer      = "nemo"
settings.editor            = os.getenv("EDITOR") or "nano"

-- Modkeys
settings.modkey            = "Mod4"
settings.altkey            = "Mod1"

-- Autorun
settings.autorun           = { settings.musicplayer, "steam", "discord" }

-- ===================================================================
-- Widgets
-- ===================================================================

-- Greeter text
settings.greeter_text      = "Welcome back"

-- Goodbyer text
settings.goodbyer_text     = "See ya later"

-- Confirmation text
settings.confirmation_text = "Are you sure?"

-- General

-- Network Interface for the widget
settings.network_interface = "enp42s0"

-- Bar

-- Taglist mode
settings.taglist_mode      = "icon" -- 'icon', 'dot', 'number', 'roman', 'alphabet'

-- RAM format
settings.ram_format        = "<used> GB" -- <used>, <free>, <available>, <usage>, <total>
settings.ram_factor        = 1024        -- The default values are in MB. So a factor of '1024' makes GB.

-- Storage format
settings.storage_format    = "<usage> %" -- <used>, <free>, <usage>, <size>
settings.storage_factor    = 1024 * 1024 -- The default values are in KB. So a factor of '1024' makes GB.

-- Clock format
settings.clock_format      = "%H : %M"

-- Date format
settings.date_format       = "%a, %B %d"

-- Dashboard

-- Enter the drives you want to get data from for the widget
settings.drive_names       = { "/", "/Games" }

-- Musicplayer art temp folder
settings.musicplayer_temp  = "/tmp"
