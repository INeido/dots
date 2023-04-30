--       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
--       ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
--       ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗
--       ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝
--       ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
--       ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Functions
-- ===================================================================

local function format_size(kilobytes)
    local units      = { "KB", "MB", "GB", "TB", "PB" }
    local unit_index = 1
    local size       = tonumber(kilobytes)
    while size >= 1024 and unit_index < #units do
        size = size / 1024
        unit_index = unit_index + 1
    end
    local formatted_size = string.format("%.1f", size)
    if formatted_size == "1000.0" and unit_index < #units then
        formatted_size = "1.0"
        unit_index = unit_index + 1
    end
    return formatted_size .. " " .. units[unit_index]
end

-- ===================================================================
-- Create Drives
-- ===================================================================

local create_widget = function(name)
    local w = wibox.widget {
        -- Header Text
        {
            text   = name,
            align  = "center",
            font   = beautiful.font .. "Bold 20",
            widget = wibox.widget.textbox,
        },
        {
            {
                -- Chart
                id            = "chart",
                max_value     = 100,
                value         = 100,
                forced_height = dpi(80),
                forced_width  = dpi(80),
                thickness     = dpi(10),
                start_angle   = math.pi * 1.5,
                rounded_edge  = true,
                bg            = beautiful.bg_minimize,
                colors        = { beautiful.accent },
                widget        = wibox.container.arcchart
            },
            {
                -- Text in the center
                id     = "val",
                align  = "center",
                font   = beautiful.font .. "Bold 14",
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.stack,
        },
        {
            -- Text underneath
            id     = "text",
            align  = "center",
            font   = beautiful.font .. "Bold 14",
            widget = wibox.widget.textbox,
        },
        spacing = dpi(10),
        layout  = wibox.layout.fixed.vertical,
    }
    return w
end

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    spacing = dpi(70),
    layout  = wibox.layout.fixed.horizontal,
}

-- ===================================================================
-- Drives
-- ===================================================================

local drives = {}
for i, v in ipairs(settings.drive_names) do
    table.insert(drives, create_widget(v))
    w:add(drives[i])
end

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::storage", function(args)
    for i, v in ipairs(drives) do
        drives[i]:get_children_by_id("chart")[1]:set_value(args.drives[i].usage)
        drives[i]:get_children_by_id("val")[1]:set_text(args.drives[i].usage .. "%")
        drives[i]:get_children_by_id("text")[1]:set_text(format_size(args.drives[i].free) .. " free")
    end
end)

return w
