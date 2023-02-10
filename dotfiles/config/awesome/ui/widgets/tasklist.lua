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
            awful.client.focus.byidx( -1)
        end))

-- ===================================================================
-- Taglist
-- ===================================================================

local w = awful.widget.tasklist {
        screen          = "primary",
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = buttons,
        widget_template = {
            {
                {
                    {
                        {
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
                    --require("naughty").notify({ title = "Achtung!", text = "asdf", timeout = 0 })

                    if not o.minimized then
                        self.bg = beautiful.accent
                    else
                        self.bg = beautiful.panel_item_normal
                    end
                end

                toggle_indicator(c)

                c:connect_signal("property::minimized", function() toggle_indicator(c) end)

                helpers.add_hover_cursor(self, "hand1")
            end
        }
    }

return w
