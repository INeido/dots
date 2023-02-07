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
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


-- ===================================================================
-- Load Widgets
-- ===================================================================

local taglist = require("ui.widgets.taglist")
local tasklist = require("ui.widgets.tasklist")
local starticon = require("ui.widgets.starticon")
local clock = require("ui.widgets.clock")
local cpu = require("ui.widgets.cpu")
local ram = require("ui.widgets.ram")
local temp = require("ui.widgets.temp")
local spotify = require("ui.widgets.spotify")
local systray = require("ui.widgets.systray")
local pacman = require("ui.widgets.pacman")
local layoutbox = require("ui.widgets.layoutbox")

-- ===================================================================
-- Wibox
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)

    -- ===================================================================
    -- Left
    -- ===================================================================

    local left = {
        widget = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        top = dpi(10),
        bottom = dpi(10),
        {
            wibox.container.margin(starticon, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(layoutbox, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(systray, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(wibox.container.background(
                wibox.layout.fixed.horizontal(
                    wibox.container.margin(taglist, dpi(0), dpi(1), dpi(0), dpi(0))
                ),
                beautiful.panel_item_normal,
                gears.shape.rect
            ), dpi(0), dpi(0), dpi(0), dpi(0)),
            layout = wibox.layout.fixed.horizontal,
        },
    }

    -- ===================================================================
    -- Middle
    -- ===================================================================

    local middle = {}
    --local clients = tasklist.filter.currenttags
    local task_count = 1

    for _, tag in pairs(awful.screen.focused().selected_tags) do
        task_count = task_count + #tag:clients()
    end

    if task_count ~= 0 then
        middle = {
            layout = wibox.layout.fixed.horizontal,
            wibox.container.margin(wibox.container.background(
                wibox.layout.fixed.horizontal(
                    wibox.container.margin(tasklist, dpi(10), dpi(10), dpi(5), dpi(5))

                ),
                beautiful.panel_item_normal,
                gears.shape.rect
            ), dpi(10), dpi(10), dpi(10), dpi(10)),
            widget = wibox.container.margin,
        }
    else
        middle = nil
    end

    -- ===================================================================
    -- Right
    -- ===================================================================

    local right = {
        widget = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        top = dpi(10),
        bottom = dpi(10),
        {
            wibox.container.margin(spotify, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(pacman, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(temp, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(cpu, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(ram, dpi(0), dpi(6), dpi(0), dpi(0)),
            wibox.container.margin(clock, dpi(0), dpi(0), dpi(0), dpi(0)),
            layout = wibox.layout.fixed.horizontal,
        },
    }

    -- ===================================================================
    -- Panel
    -- ===================================================================

    -- Create the wibox
    s.top_panel = awful.wibar({
        screen = s,
        bg = "transparent",
        height = dpi(60),
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
