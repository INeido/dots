--       ██╗   ██╗██████╗ ████████╗██╗███╗   ███╗███████╗
--       ██║   ██║██╔══██╗╚══██╔══╝██║████╗ ████║██╔════╝
--       ██║   ██║██████╔╝   ██║   ██║██╔████╔██║█████╗
--       ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██╔══╝
--       ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║███████╗
--        ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    {
        id     = "text",
        align  = "center",
        font   = beautiful.dashboardfont_small,
        widget = wibox.widget.textbox,
    },
    spacing = dpi(15),
    layout = wibox.layout.fixed.vertical,
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::uptime", function(args)
    --require("naughty").notify({ title = "Achtung!", text = args.time, timeout = 0 })

    local minutes = math.floor(args.time / 60)
    local hours = math.floor(minutes / 60)
    local days = math.floor(hours / 24)

    local text = ""

    if days > 0 then
        text = string.format("<span foreground='" .. beautiful.accent .. "'></span> %d days, %d h, %d m", days, hours % 24, minutes % 60)
    elseif hours > 0 then
        text = string.format("<span foreground='" .. beautiful.accent .. "'></span> %d hours, %d minutes", hours, minutes % 60)
    else
        text = string.format("<span foreground='" .. beautiful.accent .. "'></span> %d minutes", minutes)
    end

    w:get_children_by_id("text")[1]:set_markup(text)

    collectgarbage('collect')
end)

return w
