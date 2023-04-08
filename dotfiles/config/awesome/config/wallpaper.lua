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

local function set_wallpaper(id)
    awful.screen.connect_for_each_screen(function(s)
        local wallpaper = cache.wallpapers[id]
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end)
end

-- ===================================================================
-- Update Wallpaper
-- ===================================================================

tag.connect_signal("property::selected", function(t)
    local selected_tags = awful.screen.focused().selected_tags

    if #selected_tags > 0 then
        set_wallpaper(selected_tags[1].index)
    else
        set_wallpaper(0)
    end
end)

-- ===================================================================
-- Re-Center Wallpaper
-- ===================================================================

screen.connect_signal("property::geometry", set_wallpaper)
