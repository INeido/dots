--      ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███╗   ██╗
--      ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗████╗  ██║
--      ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝██║██║     ██║   ██║██╔██╗ ██║
--      ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██║╚██╗██║
--      ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║ ╚████║
--      ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local image = cache.power_icon

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    -- Add spacer
    {
        -- Add margins outside
        {
            -- Add background color
            {
                -- Center widget horizontally
                nil,
                {
                    -- Center widget vertically
                    nil,
                    -- The actual widget goes here
                    {
                        id = "image",
                        image = gears.color.recolor_image(image, beautiful.fg_normal),
                        widget = wibox.widget.imagebox,
                    },
                    expand = "none",
                    layout = wibox.layout.align.vertical,
                },
                expand = "none",
                layout = wibox.layout.align.horizontal,
            },
            bg = beautiful.widget_normal,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        margins = dpi(3),
        widget = wibox.container.margin,
    },
    left = dpi(10),
    widget = wibox.container.margin,
}

w:connect_signal("mouse::enter", function()
    w:get_children_by_id("image")[1]:set_image(gears.color.recolor_image(image, beautiful.fg_focus))
end)
w:connect_signal("mouse::leave", function()
    w:get_children_by_id("image")[1]:set_image(gears.color.recolor_image(image, beautiful.fg_normal))
end)

-- ===================================================================
-- Actions
-- ===================================================================

w:buttons(gears.table.join(
    awful.button({}, 1, function()
        pm_toggle()
    end)
))

return w
