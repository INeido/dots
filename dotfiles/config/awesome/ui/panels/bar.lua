--      ██████╗  █████╗ ██████╗
--      ██╔══██╗██╔══██╗██╔══██╗
--      ██████╔╝███████║██████╔╝
--      ██╔══██╗██╔══██║██╔══██╗
--      ██████╔╝██║  ██║██║  ██║
--      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


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

local starticon = require("ui.widgets.bar.starticon")
local powericon = require("ui.widgets.bar.powericon")
local layoutbox = require("ui.widgets.bar.layoutbox")
local systray = require("ui.widgets.bar.systray")
local taglist = require("ui.widgets.bar.taglist")
local tasklist = require("ui.widgets.bar.tasklist")
local spotify = require("ui.widgets.bar.spotify")
local pacman = require("ui.widgets.bar.pacman")
local date = require("ui.widgets.bar.date")
local clock = require("ui.widgets.bar.clock")

-- ===================================================================
-- Left
-- ===================================================================

local left = {
    {
        starticon,
        taglist,
        layoutbox(screen.primary),
        systray,
        layout = wibox.layout.fixed.horizontal,
    },
    left = beautiful.useless_gap * 2,
    right = beautiful.useless_gap * 2,
    top = beautiful.useless_gap * 2,
    bottom = beautiful.useless_gap * 2,
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
    left = beautiful.useless_gap,
    right = beautiful.useless_gap,
    top = beautiful.useless_gap,
    bottom = beautiful.useless_gap,
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
        powericon,
        layout = wibox.layout.fixed.horizontal,
    },
    left = beautiful.useless_gap * 2,
    right = beautiful.useless_gap * 2,
    top = beautiful.useless_gap * 2,
    bottom = beautiful.useless_gap * 2,
    widget = wibox.container.margin,
}

-- ===================================================================
-- Wibox
-- ===================================================================

-- Create the wibox
local bar = awful.wibar({
    screen = screen.primary,
    bg = beautiful.bg_normal,
    position = settings.bar_location,
    height = beautiful.bar_height,
})

-- Add widgets to the wibox
bar:setup {
    left,

    middle,

    right,

    expand = "none",
    layout = wibox.layout.align.horizontal,
}
