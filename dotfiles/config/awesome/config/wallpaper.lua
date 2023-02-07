--      ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
--      ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
--      ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
--      ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
--      ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
--       ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

-- ===================================================================
-- Load Wallpapers
-- ===================================================================

local wallpapers = {
    gears.surface.load(beautiful.wallpaper0),
    gears.surface.load(beautiful.wallpaper1),
    gears.surface.load(beautiful.wallpaper2),
    gears.surface.load(beautiful.wallpaper3),
}

-- ===================================================================
-- Set Wallpaper
-- ===================================================================

local function set_wallpaper(s, id)
    local wallpaper = wallpapers[id]
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
    else
        set_wallpaper(0, 0)
    end
end)

-- ===================================================================
-- Recenter Wallpaper
-- ===================================================================

screen.connect_signal("property::geometry", set_wallpaper)

-- ===================================================================
-- Set First Wallpaper
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s, 1)
end)
