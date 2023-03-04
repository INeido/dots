--      ████████╗ ██████╗ ██████╗       ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗      ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝█████╗██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝ ╚════╝██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║           ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝           ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝


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
-- Load Widgets
-- ===================================================================

local starticon = require("ui.widgets.top-panel.starticon")
local layoutbox = require("ui.widgets.top-panel.layoutbox")
local systray = require("ui.widgets.top-panel.systray")
local taglist = require("ui.widgets.top-panel.taglist")
local tasklist = require("ui.widgets.top-panel.tasklist")
local spotify = require("ui.widgets.top-panel.spotify")
local pacman = require("ui.widgets.top-panel.pacman")
local date = require("ui.widgets.top-panel.date")
local clock = require("ui.widgets.top-panel.clock")

-- ===================================================================
-- Wibox
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
    -- ===================================================================
    -- Left
    -- ===================================================================

    local left = {
        {
            starticon,
            layoutbox(s),
            systray,
            taglist,
            layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(10),
        right = dpi(10),
        top = dpi(10),
        widget = wibox.container.margin,
    }

    -- ===================================================================
    -- Middle
    -- ===================================================================

    local middle = {
        {
            tasklist,
            layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(10),
        right = dpi(10),
        top = dpi(10),
        widget = wibox.container.margin,
    }

    -- ===================================================================
    -- Right
    -- ===================================================================

    local right = {
        {
            spotify,
            pacman,
            date,
            clock,
            layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(10),
        right = dpi(10),
        top = dpi(10),
        widget = wibox.container.margin,
    }

    -- ===================================================================
    -- Panel
    -- ===================================================================

    -- Create the wibox
    s.top_panel = awful.wibar({
        screen = s,
        bg = "transparent",
        height = dpi(beautiful.top_panel_height),
    })

    -- Add widgets to the wibox
    s.top_panel:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",

        left,

        middle,

        right,
    }
end)
