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

settings                   = {}

-- ===================================================================
-- Important
-- ===================================================================

-- Password
settings.password          = "root"

-- Display config
settings.display           = "xrandr --output DP-0 --primary --mode 2560x1440 --pos 0x0 --rotate normal --rate 239.97"

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

-- Paths
settings.screenshot_path   = os.getenv("HOME") .. "/Pictures/"

-- ===================================================================
-- Look & Feel
-- ===================================================================

-- Layout
settings.bar_location      = "top"   -- 'top', 'bottom'
settings.bulletin_location = "right" -- 'left', 'right'

-- Switches
settings.enable_titlebar   = false
settings.sloppy_focus      = false

-- Wallpaper - If any of these change, re-render the wallpaper by deleting wp_hash.txt and restarting Awesome!
settings.wp_fullres        = false -- Can be a performance hit on slow machines
settings.wp_quality        = "80"  -- In percent
settings.wp_blur           = "08"  -- In hex

-- Notifications
settings.arc_animation_fps = "60" -- Potential performance hit

-- Tags
settings.tags              = {
	{
		layout   = awful.layout.suit.tile,
		pinned   = {},
		selected = true,
	},
	{
		layout = awful.layout.suit.max,
		pinned = { "steam", "steam_app_548430", "steam_app_730" },
	},
	{
		layout = awful.layout.suit.max,
		pinned = { settings.terminal, settings.fileexplorer, "qutebrowser", "code-oss" },
	},
	{
		layout = awful.layout.suit.floating,
		pinned = { settings.terminal, settings.fileexplorer },
	},
}

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

-- Bulletin

settings.create_embeds     = true
settings.max_embeds        = "5"

-- Bar

-- Taglist
settings.taglist_mode      = "icon" -- 'icon', 'dot', 'number', 'roman', 'alphabet'

-- RAM
settings.ram_format        = "<used> GB" -- <used>, <free>, <available>, <usage>, <total>
settings.ram_factor        = 1024        -- The default values are in MB. So a factor of '1024' makes GB.

-- Storage
settings.storage_format    = "<usage> %" -- <used>, <free>, <usage>, <size>
settings.storage_factor    = 1024 * 1024 -- The default values are in KB. So a factor of '1024' makes GB.

-- Clock
settings.clock_format      = "%H : %M"

-- Date
settings.date_format       = "%a, %B %d"

-- Pacman
settings.pacman_notif      = true

-- Dashboard

-- Enter the drives you want to get data from for the widget
settings.drive_names       = { "/", "/Games" }

-- Musicplayer art temp folder
settings.musicplayer_temp  = "/tmp"
