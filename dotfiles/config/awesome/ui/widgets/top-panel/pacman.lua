--       ██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗
--       ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║
--       ██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║
--       ██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
--       ██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
--       ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝


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
-- Get Packages
-- ===================================================================

local pacman = wibox.widget.textbox()
pacman.font = beautiful.widgetfont

-- ===================================================================
-- Icon
-- ===================================================================

local icon = wibox.widget {
    font   = beautiful.iconfont,
    markup = "<span foreground='" .. beautiful.accent .. "'> </span>",
    valign = "center",
    align  = "center",
    widget = wibox.widget.textbox,
}

-- ===================================================================
-- Widget
-- ===================================================================

-- Create the widget
local w = wibox.widget {
    -- Add margins outside
    {
        icon,
        -- Add Icon
        {
            -- Add Widget
            pacman,
            fg = beautiful.text_bright,
            widget = wibox.container.background
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    left = dpi(8),
    right = dpi(8),
}

-- Box the widget
w = helpers.box_tp_widget(w, true, 5)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip = awful.tooltip {
    objects = { w },
    mode = "outside",
    align = "right",
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

    collectgarbage('collect')
end)

-- ===================================================================
-- Buttons
-- ===================================================================

w:connect_signal("button::press", function(_, _, _, button)
    -- Run the updates in the background when left-clicked
    if button == 1 then
        -- Before the Update
        tooltip.text = "Updating..."
        -- After the update
        awful.spawn.easy_async("sudo " .. beautiful.config_path .. "scripts/pacman.sh",
        function(_, _, _, _)
            tooltip.text = "You are up to date!"
            pacman.text = 0
        end)
    end
end)

return w
