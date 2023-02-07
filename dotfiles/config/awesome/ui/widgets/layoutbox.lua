--      ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗██████╗  ██████╗ ██╗  ██╗
--      ██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝██╔══██╗██╔═══██╗╚██╗██╔╝
--      ██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║   ██████╔╝██║   ██║ ╚███╔╝
--      ██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║   ██╔══██╗██║   ██║ ██╔██╗
--      ███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║   ██████╔╝╚██████╔╝██╔╝ ██╗
--      ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   ╚═════╝  ╚═════╝ ╚═╝  ╚═╝


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

local layoutbox = wibox.widget {
    bg = beautiful.bg_subtle,
    fg = beautiful.fg_time,
    widget = wibox.container.background,
    buttons = {
      awful.button({}, 1, function()
        require "ui.widget.layoutlist"()
      end),
      awful.button({}, 4, function()
        awful.layout.inc(1)
      end),
      awful.button({}, 5, function()
        awful.layout.inc(-1)
      end),
    },
    {
      widget = wibox.container.margin,
      margins = 8,
      {
        widget = awful.widget.layoutbox,
      },
    },
  }

local w = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        margins = dpi(5),
        {
            layoutbox,
            layout = wibox.layout.fixed.horizontal,
        },
    }
}

helpers.add_hover_cursor(w, "hand1")

return w
