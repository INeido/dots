--      ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
--      ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
--      ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
--      ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
--      ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
--       ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝


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
-- Set Wallpaper
-- ===================================================================

local function set_wallpaper(s, id)
    local wallpaper = cache.wallpapers.normal[id]
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
end

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s, 0)
end)

-- ===================================================================
-- Update Wallpaper
-- ===================================================================

tag.connect_signal("property::selected", function(t)
    local tag_screen = t.screen
    local selected_tags = tag_screen.selected_tags

    if #selected_tags > 0 then
        set_wallpaper(tag_screen, selected_tags[1].index)
    else
        set_wallpaper(tag_screen, 0)
    end
end)

-- ===================================================================
-- Setup Wallpapers
-- ===================================================================

-- Calculate the current hash value
local hash = helpers.get_folder_hash(beautiful.config_path .. "wallpapers/")

-- Read the last known hash value from the file
local file = io.open(beautiful.config_path .. "wp_hash.txt", "r")
local saved_hash = file:read("*all")
file:close()

-- Compare the saved hash with the current hash to check if the folder contents have changed
if hash ~= saved_hash then
    -- Convert wallpapers to jpg (reduce file size in RAM)
    for i, wp in ipairs(cache.wallpapers.filenames) do
        helpers.convert_to_jpg(beautiful.config_path .. "wallpapers/" .. wp, settings.wallpaper_save)
    end

    -- Update cache
    cache.wallpapers = helpers.load_wallpapers()

    -- Render the blurred version of every wallpaper
    for i, wp in ipairs(cache.wallpapers.filenames) do
        helpers.blur_image(beautiful.config_path .. "wallpapers/" .. wp,
        beautiful.config_path .. "wallpapers/blurred/" .. wp, "08")
    end

    -- Save the new hash value
    file = io.open(beautiful.config_path .. "wp_hash.txt", "w")
    file:write(helpers.get_folder_hash(beautiful.config_path .. "wallpapers/"))
    file:close()
end

-- ===================================================================
-- Re-Center Wallpaper
-- ===================================================================

screen.connect_signal("property::geometry", set_wallpaper)
