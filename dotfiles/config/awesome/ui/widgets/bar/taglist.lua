--      ████████╗ █████╗  ██████╗ ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝ ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚══════╝   ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local w, arr    = nil, nil
local mode      = settings.taglist_mode
if mode == "number" then
    arr = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14" }
elseif mode == "roman" then
    arr = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII" }
elseif mode == "alphabet" then
    arr = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T" }
end

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

local function taglist(s)
    -- Create the widget
    if mode == "icon" then
        w = awful.widget.taglist {
            screen          = s,
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
                        t.icon = gears.color.recolor_image(t.icon, beautiful.fg_focus)
                    else
                        t.icon = gears.color.recolor_image(t.icon, beautiful.fg_faded)
                    end

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
                end,
                -- TO-DO: When changing tags, the widget updates on both monitors... Can't figure out why. Help.
                update_callback = function(self, t, index, tags) --luacheck: no unused args
                    if t.selected then
                        t.icon = gears.color.recolor_image(t.icon, beautiful.fg_focus)
                    else
                        t.icon = gears.color.recolor_image(t.icon, beautiful.fg_faded)
                    end
                end
            }
        }
    elseif mode == "dot" then
        w = awful.widget.taglist {
            screen          = s,
            filter          = awful.widget.taglist.filter.all,
            buttons         = buttons,
            widget_template = {
                -- Container Background
                {
                    -- Margin for Text
                    {
                        -- Text
                        id     = "text",
                        font   = beautiful.iconfont .. "14",
                        valign = "center",
                        align  = "center",
                        widget = wibox.widget.textbox,
                    },
                    left   = dpi(5),
                    right  = dpi(5),
                    widget = wibox.container.margin,
                },
                bg              = "transparent",
                widget          = wibox.container.background,
                create_callback = function(self, t, index, tags) --luacheck: no unused args
                    if t.selected then
                        self:get_children_by_id("text")[1].markup = helpers.text_color("",
                            beautiful.fg_focus)
                    else
                        self:get_children_by_id("text")[1].markup = helpers.text_color("",
                            beautiful.fg_faded)
                    end

                    self:connect_signal("mouse::enter", function()
                        if not t.selected then
                            self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                                beautiful.fg_normal)
                        end
                    end)
                    self:connect_signal("mouse::leave", function()
                        if not t.selected then
                            self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                                beautiful.fg_faded)
                        end
                    end)
                end,
                -- TO-DO: When changing tags, the widget updates on both monitors... Can't figure out why. Help.
                update_callback = function(self, t, index, tags) --luacheck: no unused args
                    if t.selected then
                        self:get_children_by_id("text")[1].markup = helpers.text_color("",
                            beautiful.fg_focus)
                    else
                        self:get_children_by_id("text")[1].markup = helpers.text_color("",
                            beautiful.fg_faded)
                    end
                end
            }
        }
    else
        w = awful.widget.taglist {
            screen          = s,
            filter          = awful.widget.taglist.filter.all,
            buttons         = buttons,
            widget_template = {
                -- Container Background
                {
                    -- Margin for Text
                    {
                        -- Text
                        id     = "text",
                        font   = beautiful.font .. "16",
                        valign = "center",
                        align  = "center",
                        widget = wibox.widget.textbox,
                    },
                    left   = dpi(5),
                    right  = dpi(5),
                    widget = wibox.container.margin,
                },
                bg              = "transparent",
                widget          = wibox.container.background,
                create_callback = function(self, t, index, tags) --luacheck: no unused args
                    if t.selected then
                        self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                            beautiful.fg_focus)
                    else
                        self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                            beautiful.fg_faded)
                    end

                    self:connect_signal("mouse::enter", function()
                        if not t.selected then
                            self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                                beautiful.fg_normal)
                        end
                    end)
                    self:connect_signal("mouse::leave", function()
                        if not t.selected then
                            self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                                beautiful.fg_faded)
                        end
                    end)
                end,
                -- TO-DO: When changing tags, the widget updates on both monitors... Can't figure out why. Help.
                update_callback = function(self, t, index, tags) --luacheck: no unused args
                    if t.selected then
                        self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                            beautiful.fg_focus)
                    else
                        self:get_children_by_id("text")[1].markup = helpers.text_color(arr[t.index],
                            beautiful.fg_faded)
                    end
                end
            }
        }
    end

    -- Box the widget
    w = helpers.box_ba_widget(w, false, 5)

    return w
end

return taglist
