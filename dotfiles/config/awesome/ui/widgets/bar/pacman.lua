--       ██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗
--       ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║
--       ██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║
--       ██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
--       ██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
--       ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local wibox     = require("wibox")
local helpers   = require("helpers")
local naughty   = require("naughty")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Get Packages
-- ===================================================================

local pacman    = wibox.widget.textbox()
pacman.font     = beautiful.font .. "11"

-- ===================================================================
-- Icon
-- ===================================================================

local icon      = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color(" ", beautiful.accent),
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w         = wibox.widget {
    -- Add margins outside
    {
        icon,
        -- Add Icon
        {
            -- Add Widget
            pacman,
            fg     = beautiful.fg_focus,
            widget = wibox.container.background
        },
        spacing = dpi(2),
        layout  = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    left   = dpi(8),
    right  = dpi(8),
}

-- Box the widget
w               = helpers.box_ba_widget(w, true, 5)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip   = awful.tooltip {
    objects             = { w },
    font                = beautiful.font .. "11",
    mode                = "outside",
    align               = "right",
    preferred_positions = { "right", "left", "bottom" }
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::pacman", function(args)
    pacman.text = args.count
    local updates = pacman.text or "0"
    local text = ""
    if updates == "0" then
        text = "You are up to date!"
    else
        text = "There are " .. updates .. " updates available."
    end

    tooltip.text = text
end)

-- ===================================================================
-- Buttons
-- ===================================================================

w:connect_signal("button::press", function(_, _, _, button)
    -- Run the updates in the background when left-clicked
    if button == 1 then
        local start_time = helpers.return_date_time('%H:%M:%S')
        -- Before the Update
        tooltip.text = "Updating..."

        -- Nothing to do
        if tonumber(pacman.text) == 0 then
            tooltip.text = "You are up to date!"
            return
        end

        -- After the update
        awful.spawn.easy_async("sudo " .. beautiful.config_path .. "scripts/pacman.sh", function(_, _, _, _)
            tooltip.text = "You are up to date!"

            local time_diff = helpers.get_time_diff(start_time)
            local time = helpers.format_time(time_diff, "<time> seconds", "<time> minutes", "<time> hours", nil)

            -- Send notification
            if settings.pacman_notif then
                naughty.notification({
                    app_name = "Pacman Widget",
                    timeout = 5,
                    title = "Update finished",
                    message = pacman.text .. " packages have been updated in " .. time .. ".",
                })
            end

            pacman.text = 0
        end)
    end
end)

return w
