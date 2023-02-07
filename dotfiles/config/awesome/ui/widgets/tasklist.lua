--      ████████╗ █████╗ ███████╗██╗  ██╗██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║███████╗█████╔╝ ██║     ██║███████╗   ██║
--         ██║   ██╔══██║╚════██║██╔═██╗ ██║     ██║╚════██║   ██║
--         ██║   ██║  ██║███████║██║  ██╗███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝

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
-- Let Click
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    -- Middle Click
    awful.button({}, 2, nil, function(c)
        c:kill()
    end),
    -- Scroll
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

-- ===================================================================
-- Taglist
-- ===================================================================

local w = awful.widget.tasklist {
    screen          = "primary",
    filter          = awful.widget.tasklist.filter.currenttags,
    buttons         = buttons,
    style           = {
        shape_border_width = 0,
        shape_border_color = '#777777',
        shape              = gears.shape.rounded_rect,
        bg_focus           = '#33333355',
        bg_normal          = '#33333322',

    },
    layout          = {
        spacing = 5,
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            {
                {
                    id     = 'icon_role',
                    widget = wibox.widget.imagebox,
                },
                left   = 5,
                right  = 5,
                widget = wibox.container.margin,
            },
            bg     = '#00000000',
            widget = wibox.container.background,
        },
        id     = 'background_role',
        widget = wibox.container.background,
    },
    create_callback = function(self, c, index, objects) --luacheck: no unused args
        self:get_children_by_id('clienticon')[1].client = c
        --self:get_children_by_id('icon_role')[1].image = "usr/share/icons/" ..beautiful.icon_theme .. '/64x64/apps/' .. c.class .. '.png'

        -- BLING: Toggle the popup on hover and disable it off hover
        self:connect_signal('mouse::enter', function()
            awesome.emit_signal("bling::task_preview::visibility",
                true, c)
        end)
        self:connect_signal('mouse::leave', function()
            awesome.emit_signal("bling::task_preview::visibility",
                false, c)
        end)
    end,
    widget          = wibox.container.background

}

return w
