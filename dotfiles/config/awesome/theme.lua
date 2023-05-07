--      ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
--      ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--         ██║   ███████║█████╗  ██╔████╔██║█████╗
--         ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--         ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local beautiful                    = require("beautiful")
local dpi                          = beautiful.xresources.apply_dpi

local theme                        = {}

theme.config_path                  = "~/.config/awesome/"

-- ===================================================================
-- Icon Theme
-- ===================================================================

theme.icon_theme                   = "Papirus"

-- ===================================================================
-- Fonts
-- ===================================================================

theme.font                         = "Inter" .. " "
theme.iconfont                     = "Font Awesome 6 Free Solid" .. " "

-- ===================================================================
-- Sizes
-- ===================================================================

theme.bar_height                   = dpi(55)

theme.systray_icon_size            = dpi(25)
theme.systray_icon_spacing         = dpi(5)

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

-- Foreground Colors
theme.fg_normal                    = "#DDDDDD"
theme.fg_focus                     = "#FFFFFF"
theme.fg_faded                     = "#AAAAAA"
theme.fg_urgent                    = "#FFFFFF"
theme.fg_minimize                  = "#FFFFFF"

-- Widget Colors
theme.widget_normal                = theme.bg_normal
theme.widget_background            = "#333333"
theme.widget_hover                 = "#3F3F3F"
theme.widget_press                 = "#4F4F4F"
theme.widget_inactive              = "#5F5F5F"
theme.widget_selected              = "#4F4F4F"
theme.widget_urgent                = "#B30000"
theme.taglist_bg_urgent            = theme.widget_urgent

-- Border Colors
theme.border_normal                = theme.widget_hover
theme.border_focus                 = theme.widget_press
theme.border_marked                = "#91231c"

-- Miscelanious Colors
theme.titlebar_button_normal       = "#888888"
theme.titlebar_button_normal_hover = "#B2B2B2"
theme.tasklist_bg_minimize         = theme.widget_normal
theme.bg_systray                   = theme.bg_normal

-- ===================================================================
-- Icons
-- ===================================================================

-- You can use your own layout icons like this:
theme.layout_floating              = theme.config_path .. "icons/layouts/floating.svg"
theme.layout_max                   = theme.config_path .. "icons/layouts/max.svg"
theme.layout_fullscreen            = theme.config_path .. "icons/layouts/fullscreen.svg"
theme.layout_tile                  = theme.config_path .. "icons/layouts/tile.svg"
theme.layout_dwindle               = theme.config_path .. "icons/layouts/dwindle.svg"

return theme
