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
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = {}

-- ===================================================================
-- Settings
-- ===================================================================

-- Switches
theme.switch_titlebar = 0


-- Border
theme.useless_gap   = dpi(5)
theme.border_width  = dpi(3)

-- ===================================================================
-- Icon Theme
-- ===================================================================

theme.icon_theme = "Papirus"

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

theme.accent = "#b5ea8c"

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

-- Text Colors
theme.text_normal = "#EEEEEE"
theme.text_bright = "#FFFFFF"
theme.text_dark   = "#DDDDDD"

-- Titlebar Button Colors
theme.titlebar_button_normal       = "#888888"
theme.titlebar_button_normal_hover = "#B2B2B2"

-- Panel Colors
theme.panel_item_normal = "#1C1E26"
theme.panel_item_hover  = "#3F3F3F"
theme.panel_item_press  = "#4F3F3F"

-- Border Colors
theme.border_normal = theme.panel_item_normal
theme.border_focus  = theme.panel_item_hover
theme.border_marked = "#91231c"

-- Tasklist Colors
theme.tasklist_bg_minimize = theme.panel_item_normal

-- ===================================================================
-- Icons
-- ===================================================================

-- You can use your own layout icons like this:
theme.layout_floating  = config_path.."icons/layouts/floating.svg"
theme.layout_max = config_path.."icons/layouts/max.svg"
theme.layout_fullscreen = config_path.."icons/layouts/fullscreen.svg"
theme.layout_tile = config_path.."icons/layouts/tile.svg"
theme.layout_dwindle = config_path.."icons/layouts/dwindle.svg"

-- Top-Panel
theme.start_icon = config_path .. "icons/arch.svg"
theme.tag_home   = config_path .. "icons/home.svg"
theme.tag_gaming = config_path .. "icons/gaming.svg"
theme.tag_dev    = config_path .. "icons/dev.svg"
theme.tag_ai     = config_path .. "icons/ai.svg"

-- Apps
theme.icon_spotify = "/usr/share/icons/" .. theme.icon_theme ..  "/64x64/apps/spotify.svg"

-- ===================================================================
-- Wallpapers
-- ===================================================================

theme.wallpaper0 = config_path .. "wallpapers/wallpaper0.jpg" -- Tag 0 (home)
theme.wallpaper1 = config_path .. "wallpapers/wallpaper1.png" -- Tag 1 (gaming)
theme.wallpaper2 = config_path .. "wallpapers/wallpaper2.jpg" -- Tag 2 (dev)
theme.wallpaper3 = config_path .. "wallpapers/wallpaper3.jpg" -- Tag 3 (ai)

return theme
