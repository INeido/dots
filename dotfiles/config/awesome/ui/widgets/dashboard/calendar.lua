--         ██████╗ █████╗ ██╗     ███████╗███╗   ██╗██████╗  █████╗ ██████╗
--        ██╔════╝██╔══██╗██║     ██╔════╝████╗  ██║██╔══██╗██╔══██╗██╔══██╗
--        ██║     ███████║██║     █████╗  ██╔██╗ ██║██║  ██║███████║██████╔╝
--        ██║     ██╔══██║██║     ██╔══╝  ██║╚██╗██║██║  ██║██╔══██║██╔══██╗
--        ╚██████╗██║  ██║███████╗███████╗██║ ╚████║██████╔╝██║  ██║██║  ██║
--         ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


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
-- Styles
-- ===================================================================

local styles    = {}
styles.month    = {
    padding      = 20,
    fg_color     = beautiful.fg_normal,
    bg_color     = transparent,
    border_width = 0,
}
styles.normal   = {}
styles.focus    = {
    fg_color = beautiful.accent,
    bg_color = transparent,
    markup   = function(t) return "<b>" .. t .. "</b>" end,
}
styles.header   = {
    fg_color = beautiful.fg_normal,
    bg_color = transparent,
    markup   = function(t) return "<span font_desc='" .. beautiful.font .. "Bold 20" .. "'>" .. t .. "</span>" end,
}

local function decorate_cell(widget, flag, _)
    if flag == "monthheader" and not styles.monthheader then
        flag = "header"
    end

    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    return wibox.widget {
        {
            widget,
            margins = (props.padding or 2) + (props.border_width or 0),
            widget  = wibox.container.margin
        },
        shape              = props.shape,
        shape_border_color = props.border_color or beautiful.bg_normal,
        shape_border_width = props.border_width or 0,
        fg                 = props.fg_color,
        bg                 = props.bg_color,
        widget             = wibox.container.background
    }
end


-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
    date          = os.date("*t"),
    font          = beautiful.font .. "Bold 10",
    long_weekdays = false,
    spacing       = dpi(3),
    forced_width  = dpi(260),
    fn_embed      = decorate_cell,
    widget        = wibox.widget.calendar.month
}

w:buttons(gears.table.join(
-- Left Click - Reset date to current date
    awful.button({}, 1, function()
        w.date = os.date("*t")
    end),
    -- Scroll - Move to previous or next month
    awful.button({}, 4, function()
        if w.date.month - 1 == os.date("*t").month then
            w.date = os.date("*t")
        else
            w.date = { month = w.date.month - 1, year = w.date.year }
        end
    end),
    awful.button({}, 5, function()
        if w.date.month + 1 == os.date("*t").month then
            w.date = os.date("*t")
        else
            w.date = { month = w.date.month + 1, year = w.date.year }
        end
    end)
))

return w
