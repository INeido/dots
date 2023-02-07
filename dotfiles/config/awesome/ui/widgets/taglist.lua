--      ████████╗ █████╗  ██████╗ ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝ ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚══════╝   ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Buttons
-- ===================================================================

local buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- ===================================================================
-- Taglist
-- ===================================================================

local w = awful.widget.taglist {
    screen          = 'primary',
    filter          = awful.widget.taglist.filter.all,
    buttons         = buttons,
    style           = {
        shape    = gears.shape.rect,
        bg_focus = beautiful.panel_item_active,
    },
    layout          = {
        spacing = 5,
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            {
                id     = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            margins = 10,
            widget  = wibox.container.margin,

        },
        id     = 'background_role',
        widget = wibox.container.background,
    }
}

return w
