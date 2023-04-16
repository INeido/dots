--       ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ ███████╗
--       ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗██╔════╝
--       ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝███████╗
--       ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║
--       ██║  ██║███████╗███████╗██║     ███████╗██║  ██║███████║
--       ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝


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

-- Colorize Text
function helpers.text_color(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers.pad(width)
    return wibox.widget {
        forced_width = width,
        layout = wibox.layout.fixed.horizontal
    }
end

function helpers.vpad(height)
    return wibox.widget {
        forced_height = height,
        layout = wibox.layout.fixed.vertical
    }
end

function helpers.add_hover_cursor(w, hover_cursor)
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
function helpers.box_db_widget(widget, width, height, background)
    background = background or beautiful.widget_normal

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
            bg = background,
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

-- For Bar Widgets
function helpers.box_tp_widget(widget, effects, margin, background)
    background = background or beautiful.widget_background

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
            bg = background,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        right = dpi(10),
        widget = wibox.container.margin,
    }

    if effects then
        w:connect_signal("mouse::enter", function()
            w:get_children_by_id("bg")[1]:set_bg(beautiful.widget_hover)
        end)
        w:connect_signal("mouse::leave", function()
            w:get_children_by_id("bg")[1]:set_bg(beautiful.widget_background)
        end)
    end

    return w
end

-- For Powermenu Widgets
function helpers.box_pm_widget(widget, width, height)
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
            bg = beautiful.widget_normal,
            forced_height = height,
            forced_width = width,
            shape = gears.shape.rect,
            widget = wibox.container.background,
        },
        margins = beautiful.useless_gap,
        widget = wibox.container.margin,
    }

    w:connect_signal("mouse::enter", function()
        pm_unfocus()
        widget:set_markup(helpers.text_color(widget:get_text(), beautiful.fg_normal))
    end)
    w:connect_signal("mouse::leave", function()
        widget:set_markup(helpers.text_color(widget:get_text(), beautiful.fg_faded))
    end)

    return w
end

function helpers.button_isfocused(widget)
    local markup = widget:get_children()[1]:get_children()[1]:get_children()[1]:get_children()[1]:get_markup()
    local text = widget:get_children()[1]:get_children()[1]:get_children()[1]:get_children()[1]:get_text()
    return markup == helpers.text_color(text, beautiful.fg_normal)
end

-- Gets all the wallpapers
function helpers.get_wallpapers(blurred)
    local wallpapers = {}
    local script = ""
    if blurred then
        script = "ls " .. beautiful.config_path .. "wallpapers/blurred/*.png"
    else
        script = "ls " .. beautiful.config_path .. "wallpapers/*.png"
    end

    local f = io.popen(script)
    for file in f:lines() do
        table.insert(wallpapers, gears.surface.load(file))
    end
    f:close()
    return wallpapers
end

-- Gets all the tag icons
function helpers.get_tag_icons()
    local icons = {}
    local script = "ls " .. beautiful.config_path .. "icons/tags/*.svg"

    local f = io.popen(script)
    for file in f:lines() do
        table.insert(icons, gears.surface.load(file))
    end
    f:close()
    return icons
end

-- Extends a panel to all screens
function helpers.extend_to_screens(panel)
    local function create_extender(s)
        local lockscreen_ext
        wibox({
            visible = false,
            ontop = true,
            type = "splash",
            screen = s
        })

        awful.placement.maximize(lockscreen_ext)

        return lockscreen_ext
    end

    local externders = {}

    -- Add panel to each screen
    awful.screen.connect_for_each_screen(function(s)
        if not s.primary then
            table.insert(externders, create_extender(s))
        end
    end)

    return externders
end

return helpers
