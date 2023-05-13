--      ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗
--      ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗
--      ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║
--      ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║
--      ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝
--      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Load Widgets
-- ===================================================================

local music     = require("ui.widgets.dashboard.music")
local clock     = require("ui.widgets.dashboard.clock")
local calendar  = require("ui.widgets.dashboard.calendar")
local network   = require("ui.widgets.dashboard.network")
local gpu       = require("ui.widgets.dashboard.gpu")
local cpu       = require("ui.widgets.dashboard.cpu")
local uptime    = require("ui.widgets.dashboard.uptime")
local storage   = require("ui.widgets.dashboard.storage")

-- ===================================================================
-- Dashboard
-- ===================================================================

local dashboard = {}

dashboard.panel = wibox({
    visible = false,
    ontop   = true,
    type    = "splash",
    screen  = screen.primary,
    bgimage = cache.wallpapers[screen.primary.index][1].blurred,
})

awful.placement.maximize(dashboard.panel)

-- ===================================================================
-- Variables
-- ===================================================================

dashboard.grabber = nil

-- ===================================================================
-- Functions
-- ===================================================================

local function close()
    awful.keygrabber.stop(dashboard.grabber)
    dashboard.panel.visible = false
    awesome.emit_signal("extender::close")
end

local function open()
    -- Reset Calendar
    calendar.date = os.date("*t")

    -- Close the Powermenu
    awesome.emit_signal("powermenu::close")

    -- Open Dashboard
    dashboard.panel.visible = true
    awesome.emit_signal("extender::open")

    -- Start Keygrabber TO-DO: Keygrabber is broken. It swallows every key and breaks the global keybinds.
    dashboard.grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key == "Escape" or key == "q" or key == "F1" or key == "d" then
            close()
            return true
        else
            return false
        end
    end)
end

local function toggle()
    if dashboard.visible then
        close()
    else
        open()
    end
end

-- ===================================================================
-- Signals
-- ===================================================================

-- Update background
tag.connect_signal("property::selected", function(t)
    helpers.update_background(dashboard.panel, t)
end)

-- Open dashboard
awesome.connect_signal("dashboard::open", function()
    open()
end)

-- Close dashboard
awesome.connect_signal("dashboard::close", function()
    close()
end)

-- Toggle dashboard
awesome.connect_signal("dashboard::toggle", function()
    toggle()
end)

-- ===================================================================
-- Setup
-- ===================================================================

dashboard.panel:setup {
    -- Center widgets vertically
    nil,
    {
        -- Center widgets horizontally
        nil,
        {
            -- Column container
            {
                -- Column 1
                helpers.box_db_widget(music, dpi(400), dpi(400)),
                {
                    helpers.box_db_widget(storage, dpi(400), dpi(190)),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                {
                    helpers.box_db_widget(gpu, dpi(200), dpi(490)),
                    helpers.box_db_widget(cpu, dpi(200), dpi(490)),
                    layout = wibox.layout.fixed.horizontal
                },
                helpers.box_db_widget(network, dpi(400), dpi(100)),
                layout = wibox.layout.fixed.vertical,
            },
            {
                -- Column 3
                helpers.box_db_widget(clock, dpi(350), dpi(100)),
                helpers.box_db_widget(calendar, dpi(350), dpi(400)),
                helpers.box_db_widget(uptime, dpi(350), dpi(80)),
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
