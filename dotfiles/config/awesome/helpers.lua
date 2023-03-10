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
    local w = wibox.widget {
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
                    expand = "none",
                    layout = wibox.layout.align.vertical,
                },
                expand = "none",
                layout = wibox.layout.align.horizontal,
            },
            bg = beautiful.panel_item_normal,
            forced_height = height,
            forced_width = width,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        margins = beautiful.useless_gap,
        widget = wibox.container.margin,
    }

    return w
end

-- For Top-Panel Widgets
helpers.box_tp_widget = function(widget, effects, margin)
    local w = wibox.widget {
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
                        expand = "none",
                        layout = wibox.layout.align.vertical,
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },
                margins = dpi(margin),
                widget = wibox.container.margin,
            },
            id = "bg",
            bg = beautiful.panel_item_normal,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        right = dpi(5),
        widget = wibox.container.margin,
    }

    if effects then
        w:connect_signal("mouse::enter", function()
            w:get_children_by_id("bg")[1]:set_bg(beautiful.panel_item_hover)
        end)
        w:connect_signal("mouse::leave", function()
            w:get_children_by_id("bg")[1]:set_bg(beautiful.panel_item_normal)
        end)
    end

    return w
end

-- For Powermenu Widgets
helpers.box_pm_widget = function(widget, action, width, height)
    local w = wibox.widget {
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
                    expand = "none",
                    layout = wibox.layout.align.vertical,
                },
                expand = "none",
                layout = wibox.layout.align.horizontal,
            },
            bg = beautiful.panel_item_normal,
            forced_height = height,
            forced_width = width,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        margins = beautiful.useless_gap,
        widget = wibox.container.margin,
    }

    w:connect_signal("mouse::enter", function()
        awesome.emit_signal("pm::focused")
        widget:set_markup("<span foreground='" .. beautiful.fg_normal .. "'>" .. widget:get_text() .. "</span>")
    end)
    w:connect_signal("mouse::leave", function()
        widget:set_markup("<span foreground='" .. beautiful.fg_deselected .. "'>" .. widget:get_text() .. "</span>")
    end)

    w:connect_signal("button::press", function()
        require("naughty").notify({ title = "Achtung!", text = "4", timeout = 0 })

        awful.spawn.with_shell(action)
    end)

    w:buttons(gears.table.join(
        awful.button({}, 1, function()
            require("naughty").notify({ title = "Achtung!", text = "5", timeout = 0 })

            awful.spawn.with_shell(action)
        end)
    ))

    return w
end

helpers.button_isfocused = function(widget)
    local markup = widget:get_children()[1]:get_children()[1]:get_children()[1]:get_children()[1]:get_markup()
    local text = widget:get_children()[1]:get_children()[1]:get_children()[1]:get_children()[1]:get_text()
    return markup == "<span foreground='" .. beautiful.fg_normal .. "'>" .. text .. "</span>"
end

-- Gets all the wallpapers
helpers.get_wallpapers = function(blurred)
    return function(callback)
        local wallpapers = {}
        local script = ""
        if blurred then
            script = "ls " .. beautiful.wallpaperpath .. "blurred/*.png"
        else
            script = "ls " .. beautiful.wallpaperpath .. "*.png"
        end

        awful.spawn.easy_async_with_shell(script, function(stdout)
            for wallpaper in string.gmatch(stdout, '[^\n]+') do
                table.insert(wallpapers, wallpaper)
            end

            callback(wallpapers)
        end)
    end
end

return helpers
