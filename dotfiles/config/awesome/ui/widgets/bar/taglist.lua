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
    screen          = screen.primary,
    filter          = awful.widget.taglist.filter.all,
    buttons         = buttons,
    widget_template = {
        -- Container Background
        {
            -- Margin for Icon
            {
                -- Icon
                id     = "icon_role",
                widget = wibox.widget.imagebox,
            },
            left   = dpi(5),
            right  = dpi(5),
            widget = wibox.container.margin,
        },
        bg              = "transparent",
        widget          = wibox.container.background,
        create_callback = function(self, t, index, tags) --luacheck: no unused args
            if t.selected then
                self:get_children_by_id("icon_role")[1]:set_image(gears.color.recolor_image(t.icon, beautiful.fg_focus))
            else
                self:get_children_by_id("icon_role")[1]:set_image(gears.color.recolor_image(t.icon, beautiful.fg_faded))
            end

            local toggle_indicator = function()
                if t.selected then
                    self:get_children_by_id("icon_role")[1]:set_image(gears.color.recolor_image(t.icon,
                        beautiful.fg_focus))
                else
                    self:get_children_by_id("icon_role")[1]:set_image(gears.color.recolor_image(t.icon,
                        beautiful.fg_faded))
                end
            end

            t:connect_signal("property::selected", function() toggle_indicator() end)

            self:connect_signal("mouse::enter", function()
                if not t.selected then
                    self:get_children_by_id("icon_role")[1]:set_image(gears.color.recolor_image(t.icon,
                        beautiful.fg_normal))
                end
            end)
            self:connect_signal("mouse::leave", function()
                if not t.selected then
                    self:get_children_by_id("icon_role")[1]:set_image(gears.color.recolor_image(t.icon,
                        beautiful.fg_faded))
                end
            end)
        end
    }
}

-- Box the widget
w = helpers.box_tp_widget(w, false, 5)

return w
