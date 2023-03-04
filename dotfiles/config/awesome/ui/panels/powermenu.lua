--      ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
--      ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗████╗ ████║██╔════╝████╗  ██║██║   ██║
--      ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
--      ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
--      ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
--      ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝


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

local goodbyer = require("ui.widgets.powermenu.goodbyer")
local buttons  = {
    require("ui.widgets.powermenu.shutdown"),
    require("ui.widgets.powermenu.reboot"),
    require("ui.widgets.powermenu.logout"),
}

-- Set the first button as active by default
buttons[1]:emit_signal("mouse::enter")

-- ===================================================================
-- Powermenu
-- ===================================================================

local powermenu = wibox({
    visible = false,
    ontop = true,
    type = "dock",
    screen = screen.primary,
})

awful.placement.maximize(powermenu)

-- ===================================================================
-- Variables
-- ===================================================================

local wp = {}
powermenu.grabber = nil

-- ===================================================================
-- Get Wallpapers
-- ===================================================================

helpers.get_wallpapers(true)(function(wallpapers)
    for _, wallpaper in ipairs(wallpapers) do
        table.insert(wp, gears.surface.load(wallpaper))
    end
    -- Set Default wallpaper
    powermenu.bgimage = wp[1]
end)

-- ===================================================================
-- Functions
-- ===================================================================

powermenu.wallpaper = function(id)
    powermenu.bgimage = wp[id]
end

powermenu.close = function()
    awful.keygrabber.stop(powermenu.grabber)
    powermenu.visible = false
end

powermenu.open = function()
    -- Close the Dashboard, if open
    awesome.emit_signal("db::close", nil)
    -- Open Powermenu
    powermenu.visible = true
    -- Start Keygrabber
    powermenu.grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key == "Escape" or key == "q" or key == "F1" then
            powermenu.close()
        elseif key == "Left" then
            local focus = false
            for i, button in ipairs(buttons) do
                if helpers.button_isfocused(button) then
                    -- Move focus to the previous button
                    if i > 1 then
                        button:emit_signal("mouse::leave")
                        buttons[i - 1]:emit_signal("mouse::enter")
                    elseif i == 1 then
                        button:emit_signal("mouse::leave")
                        buttons[#buttons]:emit_signal("mouse::enter")
                    end
                    focus = true
                    break
                end
            end
            if not focus then
                buttons[#buttons]:emit_signal("mouse::enter")
            end
        elseif key == "Right" then
            local focus = false
            for i, button in ipairs(buttons) do
                if helpers.button_isfocused(button) then
                    -- Move focus to the next button
                    if i < #buttons then
                        button:emit_signal("mouse::leave")
                        buttons[i + 1]:emit_signal("mouse::enter")
                    elseif i == #buttons then
                        button:emit_signal("mouse::leave")
                        buttons[1]:emit_signal("mouse::enter")
                    end
                    focus = true
                    break
                end
            end
            if not focus then
                buttons[1]:emit_signal("mouse::enter")
            end
        elseif key == "Return" or key == "space" then
            for _, button in ipairs(buttons) do
                if helpers.button_isfocused(button) then
                    require("naughty").notify({ title = "Achtung!", text = "1", timeout = 0 })

                    button:emit_signal("button::press")
                    require("naughty").notify({ title = "Achtung!", text = "2", timeout = 0 })
                    break
                end
            end
        end
    end)
end

powermenu.toggle = function()
    if powermenu.visible then
        powermenu.close()
    else
        powermenu.open()
    end
end

local unfocus = function()
    for i, button in ipairs(buttons) do
        button:emit_signal("mouse::leave")
    end
end

-- Setup signals
awesome.connect_signal("pm::wallpaper", powermenu.wallpaper)
awesome.connect_signal("pm::toggle", powermenu.toggle)
awesome.connect_signal("pm::close", powermenu.close)
awesome.connect_signal("pm::open", powermenu.open)
awesome.connect_signal("pm::focused", unfocus)

-- ===================================================================
-- Buttons
-- ===================================================================

powermenu:buttons(gears.table.join(
    awful.button({}, 3, function()
        --powermenu.close() -- Interrupts other widgets
    end)
))

-- ===================================================================
-- Setup
-- ===================================================================

powermenu:setup {
    -- Center widgets vertically
    nil,
    {
        -- Center widgets horizontally
        nil,
        {
            -- Column container
            goodbyer,
            {
                buttons[1],
                buttons[2],
                buttons[3],
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.fixed.vertical,
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

return powermenu
