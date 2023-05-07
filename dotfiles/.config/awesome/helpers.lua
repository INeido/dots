--       ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ ███████╗
--       ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗██╔════╝
--       ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝███████╗
--       ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║
--       ██║  ██║███████╗███████╗██║     ███████╗██║  ██║███████║
--       ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local naughty   = require("naughty")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

local cairo     = require("lgi").cairo

---@diagnostic disable: undefined-field
local helpers   = {}

-- Colorize Text
function helpers.text_color(text, color, underline)
    if underline then
        return "<span foreground='" .. color .. "'><u>" .. text .. "</u></span>"
    end
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

function helpers.return_date_time(format)
    return os.date(format)
end

function helpers.parse_to_seconds(time)
    local hourInSec = tonumber(string.sub(time, 1, 2)) * 3600
    local minInSec  = tonumber(string.sub(time, 4, 5)) * 60
    local getSec    = tonumber(string.sub(time, 7, 8))
    return (hourInSec + minInSec + getSec)
end

function helpers.get_time_diff(time)
    return helpers.parse_to_seconds(helpers.return_date_time('%H:%M:%S')) -
        helpers.parse_to_seconds(time)
end

-- Capitalize the first letter of the string
function helpers.capitalize(str)
    return str:gsub("^%l", string.upper)
end

-- Uncapitalize the first letter of the string
function helpers.uncapitalize(str)
    return str:gsub("^%u", string.lower)
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
                    return true
                else
                    return false
                end
            end
        )
    end
end

-- Jump to a client
function helpers.jump_to_client(c)
    if c then
        -- Focus the client
        client.focus = c

        -- Raise the client
        c:raise()

        -- Unminimize the client if it's minimized
        if c.minimized then
            c.minimized = false
        end

        -- Jump to the tag that has the client
        local t = c.first_tag
        if t then
            t:view_only()
        end
    end
end

-- Returns the icon for a given client
function helpers.find_icon(class, client)
    local name

    local default     = "/usr/share/icons/Papirus-Dark/128x128/apps/application-default-icon.svg"
    local resolutions = { "128x128", "96x96", "64x64", "48x48", "42x42", "32x32", "24x24", "16x16" }

    if class or client then
        if class then
            if string.match(class, "^steam_app_%d+$") then
                name = "steam_icon_" .. class:match("%d+") .. ".svg"
            else
                name = class .. ".svg"
            end
        else
            if client.class then
                name = client.class .. ".svg"
            elseif client.name then
                name = client.name .. ".svg"
            end
        end

        -- Exception for OSS version of VS Code
        if name == "code-oss.svg" then
            name = "code.svg"
        elseif name == "steamwebhelper.svg" then
            name = "Steam.svg"
        end

        for i, icon in ipairs(cache.client_icons) do
            -- Replace "-" with "%%-" to prevent match problem and memory leak
            if icon.name:match(name:gsub("-", "%%-")) then
                return cache.client_icons[i].surface
            end
        end

        for _, res in ipairs(resolutions) do
            local dir = "/usr/share/icons/" .. beautiful.icon_theme .. "/" .. res .. "/apps/"

            if io.open(dir .. helpers.uncapitalize(name), "r") ~= nil then
                cache.client_icons[#cache.client_icons + 1] = {
                    surface = gears.surface.load(dir .. helpers.uncapitalize(name)), name = name }
                return cache.client_icons[#cache.client_icons].surface
            elseif io.open(dir .. helpers.capitalize(name), "r") ~= nil then
                cache.client_icons[#cache.client_icons + 1] = {
                    surface = gears.surface.load(dir .. helpers.capitalize(name)), name = name }
                return cache.client_icons[#cache.client_icons].surface
            end
        end

        -- Fallback to steamcache icons
        if class then
            if string.match(class, "^steam_app_%d+$") then
                local dir = os.getenv("HOME") .. "/.steam/steam/appcache/librarycache/"

                if io.open(dir .. class:match("%d+") .. "_icon.jpg", "r") ~= nil then
                    cache.client_icons[#cache.client_icons + 1] = {
                        surface = gears.surface.load(dir .. class:match("%d+") .. "_icon.jpg"), name = "steam_icon_" .. class:match("%d+") .. ".svg" }
                    return cache.client_icons[#cache.client_icons].surface
                end
            end
        end

        -- Fallback to client icon or default
        if client then
            if client.icon then
                return client.icon
            else
                return gears.surface.load_uncached(default)
            end
        else
            return gears.surface.load_uncached(default)
        end
    end
end

-- Convert seconds to a time string
function helpers.format_time(seconds, sec, min, h, d)
    local minutes           = math.floor(seconds / 60)
    local hours             = math.floor(minutes / 60)
    local days              = math.floor(hours / 24)
    local seconds_remainder = seconds % 60
    local minutes_remainder = minutes % 60
    local hours_remainder   = hours % 24

    if sec ~= nil then
        sec = sec:gsub("<time>", seconds_remainder or "0") .. ""
    else
        sec = ""
    end
    if min ~= nil then
        min = min:gsub("<time>", minutes_remainder or "0") .. " "
    else
        min = ""
    end
    if h ~= nil then
        h = h:gsub("<time>", hours_remainder or "0") .. " "
    else
        h = ""
    end
    if d ~= nil then
        d = d:gsub("<time>", days or "0") .. " "
    else
        d = ""
    end

    if days > 0 then
        return d .. h .. min .. sec
    elseif hours > 0 then
        return h .. min .. sec
    elseif minutes > 0 then
        return min .. sec
    else
        return sec
    end
end

-- Copy text into clipboard
function helpers.copy_to_clipboard(text)
    os.execute(string.format("echo -n  '%s' | xclip -selection clipboard", text))
end

-- Get color of a pixel
function helpers.get_color()
    awful.spawn.easy_async_with_shell(
        [[maim -st 0 | convert - -resize 1x1\! -format '%[hex:p{0,0}]' info:-]],
        function(stdout, _, _, _)
            -- Aborted
            if stdout == nil or stdout == "" then
                return
            end

            -- Copy screenshot to clipboard
            helpers.copy_to_clipboard("#" .. string.sub(stdout, 1, 6))

            local copy_color = naughty.action {
                name = "#" .. string.sub(stdout, 1, 6) .. " (RGB)",
                icon_only = false,
            }

            copy_color:connect_signal("invoked", function()
                helpers.copy_to_clipboard("#" .. string.sub(stdout, 1, 6))
            end)

            local copy_color_opacity = naughty.action {
                name = "#" .. string.sub(stdout, 1, 8) .. " (RGBA)",
                icon_only = false,
            }

            copy_color_opacity:connect_signal("invoked", function()
                helpers.copy_to_clipboard("#" .. string.sub(stdout, 1, 8))
            end)

            local icon = gears.color.recolor_image(cache.square_icon, gears.color("#" .. string.sub(stdout, 1, 6)))

            -- Show notification
            naughty.notification({
                app_name = "Color Picker",
                icon = icon,
                timeout = 5,
                title = "Color extracted and copied to clipboard!",
                message = "Your hexcode is: #" .. string.sub(stdout, 1, 6),
                actions = { copy_color, copy_color_opacity }
            })

            collectgarbage("collect")
        end
    )
end

-- Takes a screenshot
function helpers.take_screenshot(full)
    local cmd = nil
    local file = "screenshot_" .. os.time() .. ".png"
    if full then
        cmd = "maim -uBo " .. settings.screenshot_path .. file
    else
        cmd = "maim -suBo " .. settings.screenshot_path .. file
    end

    awful.spawn.easy_async_with_shell(
        cmd,
        function(_, sterror, _, _)
            -- Aborted
            if sterror == "Selection was cancelled by keystroke or right-click.\n" then
                return
            end

            -- Copy screenshot to clipboard
            os.execute("xclip -selection clipboard -t image/png < " .. settings.screenshot_path .. file)

            local copy_image = naughty.action {
                name = "Copy",
                icon_only = false,
            }

            copy_image:connect_signal("invoked", function()
                os.execute("xclip -selection clipboard -t image/png < " .. settings.screenshot_path .. file)
            end)

            local open_folder = naughty.action {
                name = "Open Folder",
                icon_only = false,
            }

            open_folder:connect_signal("invoked", function()
                awful.spawn(settings.fileexplorer .. " " .. settings.screenshot_path, false)
            end)

            local delete_image = naughty.action {
                name = "Delete",
                icon_only = false,
            }

            delete_image:connect_signal("invoked", function()
                awful.spawn("rm " .. settings.screenshot_path .. file, false)
            end)

            -- Show notification
            naughty.notification({
                app_name = "Screenshot Tool",
                icon = settings.screenshot_path .. file,
                timeout = 5,
                title = "Screenshot taken!",
                message = "Image saved and copied to clipboard.",
                actions = { copy_image, open_folder, delete_image }
            })
        end
    )
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

-- Extracts links from a given string
function helpers.extract_link(text)
    local links = {}
    for url in text:gmatch("https?://%S+") do
        table.insert(links, url)
    end
    return links
end

-- Get website metadata
function helpers.get_website_metadata(link, callback)
    -- Handle youtu.be exception
    local domain = link:match("^https?://([^/]+)%/?.-$")

    if domain == "youtu.be" then
        link = link:gsub("youtu.be/", "www.youtube.com/watch?v=")
    end

    awful.spawn.easy_async_with_shell("curl -s '" .. link .. "'", function(stdout, stderr)
        -- Check for HTTP error
        local status_code = stdout:match("HTTP/%d%.%d (%d%d%d)")
        if status_code and (status_code:match("^4%d%d$") or status_code:match("^5%d%d$")) then
            if callback then
                callback(
                    nil,
                    "HTTP error " .. status_code)
            end
            return
        end

        local title_regex1 = "<title>(.-)</title>"
        local title_regex2 = "<meta%s+property=\"og:title\"%s+content=\"(.-)\""
        local title_regex3 = "<meta%s+name=\"title\"%s+content=\"(.-)\""

        local desc_regex1 = "<meta%s+name=\"description\"%s+content=\"(.-)\""
        local desc_regex2 = "<meta%s+property=\"og:description\"%s+content=\"(.-)\""

        local title = stdout:match(title_regex1) or stdout:match(title_regex2) or stdout:match(title_regex3)
        local description = stdout:match(desc_regex1) or stdout:match(desc_regex2)

        -- Fix HTML formatting
        if title then
            title = title:gsub("&nbsp;", " "):gsub("\n", ""):gsub("&ndash;", "-"):gsub("^%s+", "")
        else
            -- If there is no title, display the Domain name
            title = domain
        end

        -- Fix for 'Error 403' on google queries
        if title:match("^%f[Error 403]Error 403") then
            if callback then
                callback(
                    nil,
                    "HTTP error 403")
            end
            return
        end

        -- Return metadata table
        if callback then
            callback(
                title or "Untitled",
                description or "No description available."
            )
        end
    end)
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
