--       ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--       ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--       ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
--       ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
--       ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--       ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


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

local up        = wibox.widget.textbox()
up.font         = beautiful.font .. "11"

local down      = wibox.widget.textbox()
down.font       = beautiful.font .. "11"

-- ===================================================================
-- Icon
-- ===================================================================

local up_icon   = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color("↑ ", beautiful.accent),
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

local down_icon = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color("↓ ", beautiful.accent),
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
        down_icon,
        -- Add Icon
        {
            -- Add Widget
            down,
            fg     = beautiful.fg_focus,
            widget = wibox.container.background,
        },
        -- Spacer
        {
            forced_width = dpi(4),
            thickness    = 0,
            widget       = wibox.widget.separator,
        },
        up_icon,
        -- Add Icon
        {
            -- Add Widget
            up,
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

awesome.connect_signal("evil::network", function(args)
    up.text   = helpers.format_traffic(args.up)
    down.text = helpers.format_traffic(args.down)
end)

return w
