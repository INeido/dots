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
    type = "dock",
    screen = screen.primary,
})

awful.placement.maximize(dashboard)

-- ===================================================================
-- Variables
-- ===================================================================

local wp = {}
dashboard.grabber = nil

-- ===================================================================
-- Get Wallpapers
-- ===================================================================

helpers.get_wallpapers(true)(function(wallpapers)
    for _, wallpaper in ipairs(wallpapers) do
        table.insert(wp, gears.surface.load(wallpaper))
    end
    -- Set Default wallpaper
    dashboard.bgimage = wp[1]
end)

-- ===================================================================
-- Functions
-- ===================================================================

dashboard.wallpaper = function(id)
    dashboard.bgimage = wp[id]
end

dashboard.close = function()
    awful.keygrabber.stop(dashboard.grabber)
    dashboard.visible = false
end

dashboard.open = function()
    -- Close the Powermenu, if open
    awesome.emit_signal("pm::close", nil)
    -- Open Dashboard
    dashboard.visible = true
    -- Start Keygrabber
    dashboard.grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key == "Escape" or key == "q" or key == "F1" then
            dashboard.close()
        end
    end)
end

dashboard.toggle = function()
    if dashboard.visible then
        dashboard.close()
    else
        dashboard.open()
    end
end

-- Setup signals
awesome.connect_signal("db::wallpaper", dashboard.wallpaper)
awesome.connect_signal("db::toggle", dashboard.toggle)
awesome.connect_signal("db::close", dashboard.close)
awesome.connect_signal("db::open", dashboard.open)
dashboard:connect_signal("property::visible", function()
    if dashboard.visible then
        calendar.date = os.date('*t')
    end
end)

-- ===================================================================
-- Buttons
-- ===================================================================

dashboard:buttons(gears.table.join(
    awful.button({}, 3, function()
        --dashboard.close() -- Interrupts other widgets
    end)
))

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
                helpers.box_db_widget(spotify, dpi(300), dpi(300)),
                {
                    helpers.box_db_widget(storage, dpi(300), dpi(175)),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                {
                    helpers.box_db_widget(gpu, dpi(160), dpi(410)),
                    helpers.box_db_widget(cpu, dpi(160), dpi(410)),
                    layout = wibox.layout.fixed.horizontal
                },
                helpers.box_db_widget(network, dpi(320), dpi(65)),
                layout = wibox.layout.fixed.vertical,
            },
            {
                -- Column 3
                helpers.box_db_widget(clock, dpi(300), dpi(80)),
                helpers.box_db_widget(calendar, dpi(300), dpi(335)),
                helpers.box_db_widget(uptime, dpi(300), dpi(50)),
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
