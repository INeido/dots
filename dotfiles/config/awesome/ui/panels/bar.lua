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
local wibox = require("wibox")
local beautiful = require("beautiful")

-- ===================================================================
-- Load Widgets
-- ===================================================================

local starticon = require("ui.widgets.bar.starticon")
local powericon = require("ui.widgets.bar.powericon")
local layoutbox = require("ui.widgets.bar.layoutbox")
local systray = require("ui.widgets.bar.systray")
local taglist = require("ui.widgets.bar.taglist")
local tasklist = require("ui.widgets.bar.tasklist")
local music = require("ui.widgets.bar.music")
local pacman = require("ui.widgets.bar.pacman")
local date = require("ui.widgets.bar.date")
local clock = require("ui.widgets.bar.clock")
local cpu = require("ui.widgets.bar.cpu")
local ram = require("ui.widgets.bar.ram")
local temp = require("ui.widgets.bar.temp")
local network = require("ui.widgets.bar.network")
local storage = require("ui.widgets.bar.storage")
local battery = require("ui.widgets.bar.battery")

-- ===================================================================
-- Left
-- ===================================================================

local function left(s)
    return {
        {
            starticon,
            taglist(s),
            layoutbox(s),
            systray,
            layout = wibox.layout.fixed.horizontal,
        },
        left = beautiful.useless_gap * 2,
        right = beautiful.useless_gap * 2,
        top = beautiful.useless_gap * 2,
        bottom = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    }
end

-- ===================================================================
-- Middle
-- ===================================================================

local function middle(s)
    return {
        {
            tasklist(s),
            layout = wibox.layout.fixed.horizontal,
        },
        left = beautiful.useless_gap,
        right = beautiful.useless_gap,
        top = beautiful.useless_gap,
        bottom = beautiful.useless_gap,
        widget = wibox.container.margin,
    }
end

-- ===================================================================
-- Right
-- ===================================================================

local function right(s)
    return {
        {
            --battery,
            --network,
            --temp,
            --ram,
            --storage,
            --cpu,
            music,
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
end

-- ===================================================================
-- Wibox
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
    -- Create the wibox
    local bar = awful.wibar({
        screen = s,
        bg = beautiful.bg_normal,
        position = settings.bar_location,
        height = beautiful.bar_height,
    })

    -- Add widgets to the wibox
    bar:setup {
        left(s),

        middle(s),

        right(s),

        expand = "none",
        layout = wibox.layout.align.horizontal,
    }
end)
