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
local helpers = require("helpers")
local beautiful = require("beautiful")

-- ===================================================================
-- Set Wallpaper
-- ===================================================================

local function set_wallpaper(s, id)
    gears.wallpaper.set(cache.wallpapers[s.index][id].normal)
end

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s, 1)
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
        set_wallpaper(tag_screen, 1)
    end
end)

-- ===================================================================
-- Setup Wallpapers
-- ===================================================================

-- Calculate the current hash value
local hash = helpers.get_folder_hash(beautiful.config_path .. "wallpapers/")

-- Read the last known hash value from the file
local file = io.open(beautiful.config_path .. "wp_hash.txt", "r")
local saved_hash = ""
if file ~= nil then
    saved_hash = file:read("*all")
    file:close()
end

-- Compare the saved hash with the current hash to check if the folder contents have changed
if hash ~= saved_hash then
    for _, wp in ipairs(cache.wallpapers.filenames) do
        -- Convert wallpapers to jpg (reduce file size in RAM)
        helpers.convert_to_jpg(beautiful.config_path .. "wallpapers/" .. wp,
            beautiful.config_path .. "wallpapers/compressed/" .. wp)

        -- Render the blurred version of every wallpaper - These are always rendered from the compressed images
        helpers.blur_image(beautiful.config_path .. "wallpapers/compressed/" .. wp,
            beautiful.config_path .. "wallpapers/blurred/" .. wp, settings.wp_blur)
    end

    -- Update cache
    cache.wallpapers = helpers.load_wallpapers()

    -- Save the new hash value
    local file = assert(io.open(beautiful.config_path .. "wp_hash.txt", "w"))
    file:write(helpers.get_folder_hash(beautiful.config_path .. "wallpapers/"))
    file:close()
end

-- ===================================================================
-- Re-Center Wallpaper
-- ===================================================================

screen.connect_signal("property::geometry", set_wallpaper)
