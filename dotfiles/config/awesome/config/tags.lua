--      ████████╗ █████╗  ██████╗ ███████╗
--      ╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝
--         ██║   ███████║██║  ███╗███████╗
--         ██║   ██╔══██║██║   ██║╚════██║
--         ██║   ██║  ██║╚██████╔╝███████║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- ===================================================================
-- Setup Tags
-- ===================================================================

local tags = {
    { -- home
        icon = beautiful.tag_home,
        layout = awful.layout.suit.max,
        selected = true,
    },
    { -- gaming
        icon = beautiful.tag_gaming,
        layout = awful.layout.suit.max,
    },
    { -- dev
        icon = beautiful.tag_dev,
        layout = awful.layout.suit.tile,
    },
    { -- ai
        icon = beautiful.tag_ai,
        layout = awful.layout.suit.floating,
    },
}

-- ===================================================================
-- Create Tags
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
    for i, tag in pairs(tags) do
        awful.tag.add(i, {
            icon = tag.icon,
            icon_only = true,
            layout = tag.layout,
            screen = s,
            selected = tag.selected
        })
    end
end)
