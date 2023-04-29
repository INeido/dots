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

local cairo = require("lgi").cairo

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

-- Capitalize the first letter of the string
function helpers.capitalize(str)
    return str:gsub("^%l", string.upper)
end

-- Start an array of apps
function helpers.run_apps(apps)
    for _, app in ipairs(apps) do
        local client = app
        -- Some clients have a different 'CLI Name' as their class name
        if app == "spotify" then
            client = "spotify-launcher"
        end
        awful.spawn.easy_async_with_shell(
            string.format("ps aux | grep '%s' | grep -v grep | awk '{print $2}'", client),
            function(stdout)
                if stdout == "" then
                    awful.spawn(client)
                end
            end
        )
    end
end

-- Maximize the surface/image based on the screen size
function helpers.surf_maximize(surf, s)
    local w, h = gears.surface.get_size(surf)
    local geom = s.geometry
    local aspect_w, aspect_h = geom.width / w, geom.height / h

    local scaled_surf = cairo.Surface.create_similar(surf, cairo.Content.COLOR_ALPHA, geom.width, geom.height)
    local cr = cairo.Context(scaled_surf)

    cr:scale(aspect_w, aspect_h)
    cr:set_source_surface(surf, 0, 0)
    cr:paint()

    surf:finish()

    return scaled_surf
end

-- Blur a given image
function helpers.blur_image(image, save_path, radius)
    os.execute(string.format("convert %s -blur 0x%s %s", image, radius, save_path))
end

-- Convert a given image to JPG
function helpers.convert_to_jpg(image, save_path)
    os.execute(string.format("convert %s -quality " .. settings.wp_quality .. " %s", image,
    save_path:gsub("%.png", ".jpg")))
end

-- Updates the background of a given panel
function helpers.update_background(panel, tag)
    if tag.selected == true then
        local selected_tags = panel.screen.selected_tags

        if #selected_tags > 0 then
            panel.bgimage = cache.wallpapers[panel.screen.index][selected_tags[1].index].blurred
        else
            panel.bgimage = cache.wallpapers[panel.screen.index][1].blurred
        end
    end
end

-- Calculates the hash of a folder
function helpers.get_folder_hash(folder)
    local cmd = "cd " .. folder .. " && find . -type f -print0 | sort -z | xargs -0 md5sum | md5sum"
    local f = assert(io.popen(cmd, 'r'))
    local hash = f:read('*a')
    f:close()
    return hash:sub(1, -2)
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
function helpers.box_ba_widget(widget, effects, margin, background)
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

-- Loads all the wallpapers
function helpers.load_wallpapers()
    local wallpapers = { filenames = {} }
    local temp = { normal = {}, blurred = {} }

    local script_normal
    if settings.wp_fullres then
        script_normal = "ls " .. beautiful.config_path .. "wallpapers/*.*"
    else
        script_normal = "ls " .. beautiful.config_path .. "wallpapers/compressed/*.*"
    end
    local script_blurred = "ls " .. beautiful.config_path .. "wallpapers/blurred/*.*"

    -- Load normal wallpapers
    local f = io.popen(script_normal)
    for file in f:lines() do
        table.insert(temp.normal, gears.surface.load(file))
        -- Save the filenames
        local filename = file:match(".+/([^/]+)$") -- Extract the filename portion of the path
        table.insert(wallpapers.filenames, filename)
    end
    f:close()

    -- Load blurred wallpapers
    f = io.popen(script_blurred)
    for file in f:lines() do
        table.insert(temp.blurred, gears.surface.load(file))
    end
    f:close()

    -- Scales the wallpapers for every different screen
    awful.screen.connect_for_each_screen(function(s)
        wallpapers[s.index] = {}

        for i, tag in ipairs(settings.tags) do
            wallpapers[s.index][i] = { normal = nil, blurred = nil }

            wallpapers[s.index][i].normal = helpers.surf_maximize(temp.normal[i], s)
            wallpapers[s.index][i].blurred = helpers.surf_maximize(temp.blurred[i], s)
        end
    end)

    return wallpapers
end

-- Loads all the tag icons
function helpers.load_tag_icons()
    local icons = {}
    local script = "ls " .. beautiful.config_path .. "icons/tags/*.svg"

    local f = io.popen(script)
    for file in f:lines() do
        table.insert(icons, gears.surface.load(file))
    end
    f:close()
    return icons
end


function helpers.format_traffic(val)
    local bytes = val / 1024
    if bytes > 1024 ^ 3 then
      return string.format("%.2f GB/s", bytes / 1024 ^ 3)
    elseif bytes > 1024 ^ 2 then
      return string.format("%.2f MB/s", bytes / 1024 ^ 2)
    elseif bytes > 1024 then
      return string.format("%.2f KB/s", bytes / 1024)
    else
      return string.format("%.0f B/s", bytes)
    end
  end

return helpers
