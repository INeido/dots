--       ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ ███████╗
--       ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗██╔════╝
--       ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝███████╗
--       ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║
--       ██║  ██║███████╗███████╗██║     ███████╗██║  ██║███████║
--       ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝

-- Dashboard Version

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

---@diagnostic disable: undefined-field
local helpers = {}

helpers.add_hover_cursor = function(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal("mouse::enter", function()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = hover_cursor
        end
    end)

    w:connect_signal("mouse::leave", function()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = original_cursor
        end
    end)
end

-- For Dashboard Widgets
helpers.box_db_widget = function(widget, width, height)
    return wibox.widget {
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget horizontally
                nil,
                {
                    -- Center widget vertically
                    nil,
                    -- The actual widget goes here
                    widget,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            bg = beautiful.panel_item_normal,
            forced_height = height,
            forced_width = width,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        margins = beautiful.useless_gap,
        widget = wibox.container.margin
    }
end

-- For Top-Panel Widgets
helpers.box_tp_widget = function(widget)
    return wibox.widget {
        -- Add margins outside
        {
            -- Add background color
            {
                -- Add margins inside
                {
                    -- Center widget horizontally
                    nil,
                    {
                        -- Center widget vertically
                        nil,
                        -- The actual widget goes here
                        widget,
                        layout = wibox.layout.align.vertical,
                        expand = "none"
                    },
                    layout = wibox.layout.align.horizontal,
                    expand = "none"
                },
                margins = dpi(5),
                widget = wibox.container.margin,
            },
            bg = beautiful.panel_item_normal,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        right = dpi(5),
        widget = wibox.container.margin,
    }
end

return helpers
