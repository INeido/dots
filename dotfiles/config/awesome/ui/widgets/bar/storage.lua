--       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
--       ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
--       ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗
--       ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝
--       ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
--       ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Functions
-- ===================================================================

local function applyformat(args)
    local str = settings.storage_format
    local factor = settings.storage_factor

    str = str:gsub("<size>", string.format("%.1f", args.size / factor) or "0")
    str = str:gsub("<used>", string.format("%.1f", args.used / factor) or "0")
    str = str:gsub("<free>", string.format("%.1f", args.free / factor) or "0")
    str = str:gsub("<usage>", args.usage or "0")
    return str
end

-- ===================================================================
-- Textbox
-- ===================================================================

local storage = wibox.widget.textbox()
storage.font = beautiful.font .. "11"

-- ===================================================================
-- Icon
-- ===================================================================

local icon = wibox.widget {
    font   = beautiful.iconfont .. "11",
    markup = helpers.text_color(" ", beautiful.accent),
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
            storage,
            fg = beautiful.fg_focus,
            widget = wibox.container.background,
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    left = dpi(8),
    right = dpi(8),
}

-- Box the widget
w = helpers.box_ba_widget(w, false, 5)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip = awful.tooltip {
    objects = { w },
    font = beautiful.font .. "11",
    mode = "outside",
    align = "right",
    preferred_positions = { "right", "left", "bottom" }
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::storage", function(args)
    storage.text = applyformat(args.drives[1])
    tooltip.text = "Total: " .. string.format("%.1f", args.drives[1].size / settings.storage_factor)
        .. " GB\n" .. "Used: " .. string.format("%.1f", args.drives[1].used / settings.storage_factor)
        .. " GB\n" .. "Free: " .. string.format("%.1f", args.drives[1].free / settings.storage_factor) .. " GB"
end)

return w
