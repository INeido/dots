--      ██████╗ ██╗   ██╗████████╗████████╗ ██████╗ ███╗   ██╗
--      ██╔══██╗██║   ██║╚══██╔══╝╚══██╔══╝██╔═══██╗████╗  ██║
--      ██████╔╝██║   ██║   ██║      ██║   ██║   ██║██╔██╗ ██║
--      ██╔══██╗██║   ██║   ██║      ██║   ██║   ██║██║╚██╗██║
--      ██████╔╝╚██████╔╝   ██║      ██║   ╚██████╔╝██║ ╚████║
--      ╚═════╝  ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Widget
-- ===================================================================

local function button(icon)
    local w = wibox.widget {
        text   = icon,
        markup = helpers.text_color(icon, beautiful.fg_focus),
        valign = "center",
        align  = "center",
        font   = beautiful.iconfont .. " 35",
        widget = wibox.widget.textbox,
    }

    -- Box the widget
    w = helpers.box_pm_widget(w, dpi(100), dpi(100))

    return w
end

return button
