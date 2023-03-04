--      ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
--      ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--         ██║   ███████║█████╗  ██╔████╔██║█████╗
--         ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--         ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local theme_assets                 = require("beautiful.theme_assets")
local beautiful                    = require("beautiful")
local dpi                          = beautiful.xresources.apply_dpi

local config_path                  = "~/.config/awesome/"
local gears                        = require("gears")
local gfs                          = require("gears.filesystem")

local theme                        = {}
theme.config_path                  = "~/.config/awesome/"

-- ===================================================================
-- Settings
-- ===================================================================

-- Apps
theme.terminal                     = "alacritty"
theme.browser                      = "firefox"
theme.fileexplorer                 = "thunar"
theme.editor                       = os.getenv("EDITOR") or "nano"

-- Switches
theme.enable_titlebar              = false

-- Network Interface for the widget
theme.network_interface            = "enp42s0"

-- Enter the drives you want to get data for the widget
theme.drive_names                  = { "/", "/Games" }

-- Spotify art temp folder
theme.spotify_temp                 = "/tmp"

-- ===================================================================
-- Icon Theme
-- ===================================================================

theme.icon_theme                   = "Papirus"

-- ===================================================================
-- Fonts
-- ===================================================================

theme.font                         = "Inter 9"
theme.widgetfont_small             = "Inter Bold 10"
theme.widgetfont                   = "Inter Bold 10"
theme.widgetfont_big               = "Inter Bold 14"
theme.dashboardfont_small          = "Inter Bold 16"
theme.dashboardfont_thin           = "Inter 16"
theme.dashboardfont_normal         = "Inter Bold 20"
theme.dashboardfont_big            = "Inter Bold 25"
theme.dashboardfont_huge           = "Inter Bold 30"
theme.titlefont                    = "Inter 9"
theme.fontname                     = "Inter 9"
theme.iconfont                     = "Font Awesome 6 Free Solid 11"
theme.iconfont_medium              = "Font Awesome 6 Free Solid 18"
theme.iconfont_big                 = "Font Awesome 6 Free Solid 22"
theme.iconfont_bigger              = "Font Awesome 6 Free Solid 24"
theme.iconfont_huge                = "Font Awesome 6 Free Solid 30"
theme.iconfont_massive             = "Font Awesome 6 Free Solid 50"

-- ===================================================================
-- Sizes
-- ===================================================================

theme.top_panel_height             = dpi(50)

theme.systray_icon_size            = dpi(29)

theme.useless_gap                  = dpi(5)
theme.border_width                 = dpi(3)

-- ===================================================================
-- Colors
-- ===================================================================

theme.accent                       = "#B5EA8C"

-- Background Colors
theme.bg_normal                    = "#1E1E1E"
theme.bg_focus                     = "#1C1E26"
theme.bg_urgent                    = "#1C1E26"
theme.bg_minimize                  = "#AAAAAA"
theme.bg_systray                   = theme.bg_normal
theme.bg_dashboard                 = "#1C1E2688"

-- Foreground Colors
theme.fg_normal                    = "#DDDDDD"
theme.fg_deselected                = "#AAAAAA"
theme.fg_focus                     = "#FFFFFF"
theme.fg_urgent                    = "#FFFFFF"
theme.fg_minimize                  = "#FFFFFF"

-- Text Colors
theme.text_normal                  = "#EEEEEE"
theme.text_bright                  = "#FFFFFF"
theme.text_dark                    = "#DDDDDD"

-- Titlebar Button Colors
theme.titlebar_button_normal       = "#888888"
theme.titlebar_button_normal_hover = "#B2B2B2"

-- Panel Colors
theme.panel_item_normal            = "#1E1E1E"
theme.panel_item_hover             = "#3F3F3F"
theme.panel_item_press             = "#4F4F4F"
theme.panel_item_inactive          = "#5F5F5F"
theme.panel_item_selected          = "#FFFFFF"
theme.panel_item_urgent            = "#B30000"
theme.taglist_bg_urgent            = theme.panel_item_urgent

-- Dashboard Colors
theme.dashboard_item_normal        = "#1E1E1E"
theme.dashboard_item_hover         = "#3F3F3F"
theme.dashboard_item_press         = "#4F3F3F"
theme.dashboard_item_inactive      = "#4F3F3F"
theme.dashboard_item_selected      = "#4F3F3F"
theme.dashboard_item_urgent        = "#4F3F3F"

-- Border Colors
theme.border_normal                = theme.panel_item_normal
theme.border_focus                 = theme.panel_item_hover
theme.border_marked                = "#91231c"

-- Tasklist Colors
theme.tasklist_bg_minimize         = theme.panel_item_normal

-- ===================================================================
-- Icons
-- ===================================================================

-- You can use your own layout icons like this:
theme.layout_floating              = config_path .. "icons/layouts/floating.svg"
theme.layout_max                   = config_path .. "icons/layouts/max.svg"
theme.layout_fullscreen            = config_path .. "icons/layouts/fullscreen.svg"
theme.layout_tile                  = config_path .. "icons/layouts/tile.svg"
theme.layout_dwindle               = config_path .. "icons/layouts/dwindle.svg"

-- Top-Panel - You can change the icons for your tags here
theme.start_icon                   = config_path .. "icons/arch.svg"
theme.tag_home                     = config_path .. "icons/home.svg"
theme.tag_gaming                   = config_path .. "icons/gaming.svg"
theme.tag_dev                      = config_path .. "icons/dev.svg"
theme.tag_ai                       = config_path .. "icons/ai.svg"

-- Apps
theme.icon_spotify                 = "/usr/share/icons/" .. theme.icon_theme .. "/128x128/apps/spotify.svg"

-- ===================================================================
-- Wallpapers
-- ===================================================================

-- You can change the wallpapers for your tags here
theme.wallpaperpath                = config_path .. "wallpapers/"

return theme
