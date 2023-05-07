--      ████████╗███████╗███╗   ███╗██████╗
--      ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗
--         ██║   █████╗  ██╔████╔██║██████╔╝
--         ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝
--         ██║   ███████╗██║ ╚═╝ ██║██║
--         ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Textbox
-- ===================================================================

local ram       = wibox.widget.textbox()
ram.font        = beautiful.font .. "11"

-- ===================================================================
-- Icon
-- ===================================================================

local icon      = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color(" ", beautiful.accent),
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w         = wibox.widget {
    -- Add margins outside
    {
        icon,
        -- Add Icon
        {
            -- Add Widget
            ram,
            fg     = beautiful.fg_focus,
            widget = wibox.container.background,
        },
        spacing = dpi(2),
        layout  = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    left   = dpi(8),
    right  = dpi(8),
}

-- Box the widget
w               = helpers.box_ba_widget(w, false, 5)

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::temp", function(args)
    ram.text = args.cpu .. " °C"
end)

return w