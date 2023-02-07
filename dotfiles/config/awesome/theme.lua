--      ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
--      ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--         ██║   ███████║█████╗  ██╔████╔██║█████╗
--         ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--         ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local theme_assets = require("beautiful.theme_assets")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local config_path = "~/.config/awesome/"
local icon_path = "/usr/share/icons/Papirus/"
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = {}

-- ===================================================================
-- Fonts
-- ===================================================================

theme.font       = "Inter 9"
theme.widgetfont = "Inter Bold 10"
theme.titlefont  = "Inter 9"
theme.fontname   = "Inter 9"
theme.iconfont   = "Font Awesome 6 Free Solid 11"

-- ===================================================================
-- Colors
-- ===================================================================

-- Background Colors
theme.scheme = "#b5ea8c"

-- Background Colors
theme.bg_normal   = "#1C1E26"
theme.bg_focus    = "#1C1E26"
theme.bg_urgent   = "#1C1E26"
theme.bg_minimize = "#aaaaaa"
theme.bg_systray  = theme.bg_normal

-- Foreground Colors
theme.fg_normal   = "#DDDDDD"
theme.fg_focus    = "#FFFFFF"
theme.fg_urgent   = "#FFFFFF"
theme.fg_minimize = "#FFFFFF"

-- Foreground Colors
theme.text_normal = "#EEEEEE"
theme.text_bright = "#FFFFFF"
theme.text_dark   = "#DDDDDD"

-- Border Colors
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- Titlebar Button Colors
theme.titlebar_button_normal       = "#888888"
theme.titlebar_button_normal_hover = "#B2B2B2"

-- Panel Colors
theme.panel_item_normal = "#1C1E26"
theme.panel_item_focus  = "#3F3F3F"
theme.panel_item_hover  = "#3F3F3F"
theme.panel_item_press  = "#3F3F3F"
theme.panel_item_select = "#505050"
theme.panel_item_active = "#606060"

-- ===================================================================
-- Icons
-- ===================================================================

-- Apps
theme.spotify_icon = icon_path .. "64x64/apps/spotify-client.svg"

-- Top-Panel
theme.start_icon = config_path .. "icons/arch.svg"
theme.tag_home   = config_path .. "icons/home.svg"
theme.tag_gaming = config_path .. "icons/gaming.svg"
theme.tag_dev    = config_path .. "icons/dev.svg"
theme.tag_ai     = config_path .. "icons/ai.svg"

-- ===================================================================
-- Wallpapers
-- ===================================================================

theme.wallpaper0 = config_path .. "wallpapers/wallpaper0.jpg" -- Tag 0 (home)
theme.wallpaper1 = config_path .. "wallpapers/wallpaper1.png" -- Tag 1 (gaming)
theme.wallpaper2 = config_path .. "wallpapers/wallpaper2.jpg" -- Tag 2 (dev)
theme.wallpaper3 = config_path .. "wallpapers/wallpaper3.jpg" -- Tag 3 (ai)

-- ===================================================================
-- Icon Theme
-- ===================================================================

theme.icon_theme = "Papirus"

return theme
