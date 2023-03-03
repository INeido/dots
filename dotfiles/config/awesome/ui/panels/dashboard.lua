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

local spotify_db = require("ui.widgets.spotify_db")
local clock_db = require("ui.widgets.clock_db")
local calendar_db = require("ui.widgets.calendar_db")
local network_db = require("ui.widgets.network_db")
local gpu_db = require("ui.widgets.gpu_db")
local cpu_db = require("ui.widgets.cpu_db")
local uptime_db = require("ui.widgets.uptime_db")
local storage_db = require("ui.widgets.storage_db")

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
-- Get Wallpapers
-- ===================================================================

local wp = {}

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
    awful.keygrabber.stop(dashboard_grabber)
    dashboard.visible = false
end

dashboard.open = function()
    dashboard_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        -- Press Escape or q or F1 to hide it
        if key == 'Escape' or key == 'q' or key == 'd' or key == 'F1' then
            dashboard.close()
        else
            -- Pass all other key events to the system TO-DO: Doenst work
            awful.key.execute(key, event)
        end
    end)
    dashboard.visible = true
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
        calendar_db.date = os.date('*t')
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
                helpers.box_db_widget(spotify_db, dpi(300), dpi(300)),
                {
                    helpers.box_db_widget(storage_db, dpi(300), dpi(175)),
                    --helpers.box_db_widget(cpu_db, dpi(160), dpi(410)),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                {
                    helpers.box_db_widget(gpu_db, dpi(160), dpi(410)),
                    helpers.box_db_widget(cpu_db, dpi(160), dpi(410)),
                    layout = wibox.layout.fixed.horizontal
                },
                helpers.box_db_widget(network_db, dpi(320), dpi(65)),
                layout = wibox.layout.fixed.vertical,
            },
            {
                -- Column 3
                helpers.box_db_widget(clock_db, dpi(300), dpi(80)),
                helpers.box_db_widget(calendar_db, dpi(300), dpi(335)),
                helpers.box_db_widget(uptime_db, dpi(300), dpi(50)),
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
