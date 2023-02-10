--       ██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗
--       ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║
--       ██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║
--       ██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
--       ██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
--       ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Get Packages
-- ===================================================================

local pacman = wibox.widget.textbox()
pacman.font = beautiful.widgetfont

awesome.connect_signal("evil::pacman", function(args)
    pacman.text = args.count
    collectgarbage('collect')
end)

-- ===================================================================
-- Icon
-- ===================================================================

local widget_icon = " "
local icon = wibox.widget {
        font   = beautiful.iconfont,
        markup = "<span foreground='" .. beautiful.accent .. "'>" .. widget_icon .. "</span>",
        widget = wibox.widget.textbox,
        valign = "center",
        align  = "center"
    }

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.panel_item_normal,
        shape = gears.shape.rect,
        {
            widget = wibox.container.margin,
            left = dpi(10),
            right = dpi(10),
            top = dpi(5),
            bottom = dpi(5),
            {
                icon,
                {
                    pacman,
                    fg = beautiful.text_bright,
                    widget = wibox.container.background
                },
                spacing = dpi(2),
                layout = wibox.layout.fixed.horizontal
            }
        }
    }

-- ===================================================================
-- Tooltip
-- ===================================================================

w:connect_signal("mouse::enter", function()
    local updates = pacman.text or "0"
    local text = ""
    if updates == "0" then
        text = "You are up to date!"
    else
        text = "There are " .. updates .. " updates available."
    end

    awful.tooltip {
        objects = { w },
        text = text,
        mode = "outside",
        align = "right",
        preferred_positions = { "right", "left", "bottom" }
    }
end)

return w
