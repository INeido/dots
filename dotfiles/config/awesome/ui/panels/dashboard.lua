--      ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗
--      ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗
--      ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║
--      ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║
--      ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝
--      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝


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

local spotify = require("ui.widgets.dashboard.spotify")
local clock = require("ui.widgets.dashboard.clock")
local calendar = require("ui.widgets.dashboard.calendar")
local network = require("ui.widgets.dashboard.network")
local gpu = require("ui.widgets.dashboard.gpu")
local cpu = require("ui.widgets.dashboard.cpu")
local uptime = require("ui.widgets.dashboard.uptime")
local storage = require("ui.widgets.dashboard.storage")

-- ===================================================================
-- Dashboard
-- ===================================================================

local dashboard = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    screen = screen.primary,
    bgimage = cache.wallpapers_blurred[1],
})

awful.placement.maximize(dashboard)

-- ===================================================================
-- Variables
-- ===================================================================

dashboard.grabber = nil

-- ===================================================================
-- Functions
-- ===================================================================

function db_close()
    awful.keygrabber.stop(dashboard.grabber)
    dashboard.visible = false
end

function db_open()
    -- Reset Calendar
    if dashboard.visible then
        calendar.date = os.date("*t")
    end
    -- Close the Powermenu
    pm_close()
    -- Open Dashboard
    dashboard.visible = true
    -- Start Keygrabber TO-DO: Keygrabber is broken. It swallows every key and breaks the global keybinds.
    dashboard.grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key == "Escape" or key == "q" or key == "F1" or key == "d" then
            db_close()
            return true
        else
            return false
        end
    end)
end

function db_toggle()
    if dashboard.visible then
        db_close()
    else
        db_open()
    end
end

-- ===================================================================
-- Signals
-- ===================================================================

-- Update background
tag.connect_signal("property::selected", function(t)
    local selected_tags = awful.screen.focused().selected_tags

    if #selected_tags > 0 then
        dashboard.bgimage = cache.wallpapers_blurred[selected_tags[1].index]
    else
        dashboard.bgimage = cache.wallpapers_blurred[1]
    end
end)

-- ===================================================================
-- Setup
-- ===================================================================

dashboard:setup {
    -- Center widgets vertically
    nil,
    {
        -- Center widgets horizontally
        nil,
        {
            -- Column container
            {
                -- Column 1
                helpers.box_db_widget(spotify, dpi(300), dpi(300), beautiful.panel_item_normal),
                {
                    helpers.box_db_widget(storage, dpi(300), dpi(175), beautiful.panel_item_normal),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                {
                    helpers.box_db_widget(gpu, dpi(160), dpi(410), beautiful.panel_item_normal),
                    helpers.box_db_widget(cpu, dpi(160), dpi(410), beautiful.panel_item_normal),
                    layout = wibox.layout.fixed.horizontal
                },
                helpers.box_db_widget(network, dpi(320), dpi(65), beautiful.panel_item_normal),
                layout = wibox.layout.fixed.vertical,
            },
            {
                -- Column 3
                helpers.box_db_widget(clock, dpi(300), dpi(80), beautiful.panel_item_normal),
                helpers.box_db_widget(calendar, dpi(300), dpi(335), beautiful.panel_item_normal),
                helpers.box_db_widget(uptime, dpi(300), dpi(50), beautiful.panel_item_normal),
                layout = wibox.layout.fixed.vertical
            },
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

return dashboard
