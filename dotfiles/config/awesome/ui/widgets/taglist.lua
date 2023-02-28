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
local helpers = require("helpers")
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

-- Create the widget
local w = awful.widget.taglist {
        screen          = "primary",
        filter          = awful.widget.taglist.filter.all,
        buttons         = buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id     = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = dpi(3),
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

            create_callback = function(self, t, index, tags) --luacheck: no unused args
                local toggle_indicator = function(o)
                    if o.selected then
                        self.bg = beautiful.accent
                    else
                        self.bg = beautiful.panel_item_normal
                    end
                end

                toggle_indicator(t)

                t:connect_signal("property::selected", function() toggle_indicator(t) end)

                helpers.add_hover_cursor(self, "hand1")
            end
        }
    }

-- Box the widget
w = helpers.box_tp_widget(w)

return w
