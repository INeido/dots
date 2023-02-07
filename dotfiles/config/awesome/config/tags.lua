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
local naughty = require('naughty')

-- ===================================================================
-- Setup Tags
-- ===================================================================

local tags = {
    { -- home
        icon = beautiful.tag_home,
        selected = true
    },
    { -- gaming
        icon = beautiful.tag_gaming,
    },
    { -- dev
        icon = beautiful.tag_dev,
    },
    { -- ai
        icon = beautiful.tag_ai,
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
            layout = awful.layout.layouts[1],
            screen = s,
            selected = tag.selected
        })
    end
end)
