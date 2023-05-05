--       ██╗   ██╗██████╗ ████████╗██╗███╗   ███╗███████╗
--       ██║   ██║██╔══██╗╚══██╔══╝██║████╗ ████║██╔════╝
--       ██║   ██║██████╔╝   ██║   ██║██╔████╔██║█████╗
--       ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██╔══╝
--       ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║███████╗
--        ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Widget
-- ===================================================================

local w         = wibox.widget {
    {
        -- Text
        id     = "text",
        align  = "center",
        font   = beautiful.font .. "Bold 18",
        widget = wibox.widget.textbox,
    },
    spacing = dpi(15),
    layout  = wibox.layout.fixed.vertical,
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::uptime", function(args)
    local text = helpers.text_color(" ", beautiful.accent) ..
    helpers.format_time(args.time, nil, "<time> min", "<time> hours", "<time> days")

    w:get_children_by_id("text")[1]:set_markup(text)
end)

return w
