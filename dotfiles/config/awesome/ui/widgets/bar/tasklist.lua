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
local helpers = require("helpers")
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

-- Create the Widget
local w = awful.widget.tasklist {
    screen          = screen.primary,
    filter          = awful.widget.tasklist.filter.currenttags,
    buttons         = buttons,
    widget_template = {
        -- Selected Indicator
        {
            -- Margin for Indicator
            {
                -- Container Background
                {
                    -- Margin for Icon
                    {
                        -- Icon
                        id     = "clienticon",
                        widget = awful.widget.clienticon,
                    },
                    margins = dpi(6),
                    widget  = wibox.container.margin,
                },
                id     = "background_role",
                widget = wibox.container.background,
            },
            bottom = dpi(4),
            widget = wibox.container.margin,
        },
        id = "indicator_role",
        shape = gears.shape.rect,
        widget = wibox.container.background,
        create_callback = function(self, c, index, clients) --luacheck: no unused args
            self:get_children_by_id("clienticon")[1].client = c

            local toggle_indicator = function(o)
                if not o.minimized then
                    self.bg = beautiful.accent
                elseif o.urgent then
                    self.bg = beautiful.widget_urgent
                else
                    self.bg = beautiful.widget_normal
                end
            end

            toggle_indicator(c)

            c:connect_signal("property::minimized", function() toggle_indicator(c) end)

            self:connect_signal("mouse::enter", function()
                self:get_children_by_id("background_role")[1]:set_bg(beautiful.widget_hover)
            end)
            self:connect_signal("mouse::leave", function()
                self:get_children_by_id("background_role")[1]:set_bg(beautiful.widget_normal)
            end)
        end
    }
}

return w
