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
-- Load Wallpapers
-- ===================================================================

local wp = {}

helpers.get_wallpapers(function(wallpapers)
    for _, wallpaper in ipairs(wallpapers) do
        table.insert(wp, gears.surface.load(wallpaper))
    end
end)

-- ===================================================================
-- Set Wallpaper
-- ===================================================================

local function set_wallpaper(s, id)
    local wallpaper = wp[id]
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
end

-- ===================================================================
-- Change Wallpaper
-- ===================================================================

tag.connect_signal("property::selected", function(t)
    local selected_tags = awful.screen.focused().selected_tags

    if #selected_tags > 0 then
        set_wallpaper(0, selected_tags[1].index)
        awesome.emit_signal("db::wallpaper", selected_tags[1].index)
    else
        set_wallpaper(0, 0)
        awesome.emit_signal("db::wallpaper", 1)
    end
end)

-- ===================================================================
-- Re-Center Wallpaper
-- ===================================================================

screen.connect_signal("property::geometry", set_wallpaper)

-- ===================================================================
-- Set First Wallpaper
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s, 1)
end)
