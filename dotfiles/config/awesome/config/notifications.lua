--      ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--      ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--      ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--      ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--      ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--      ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Config
-- ===================================================================

-- This breaks the notifications
--[[
naughty.config.defaults = {
  timeout = 5,
  position = "top_right",
  margin = dpi(10),
  height = dpi(80),
  width = dpi(300),
  font = beautiful.font .. "14",
  bg = beautiful.bg_normal,
  fg = beautiful.fg_normal,
  border_width = 0,
  border_color = beautiful.bg_normal,
  --shape = gears.shape.rounded_rect,
}
]]--

-- ===================================================================
-- Presets
-- ===================================================================

naughty.config.presets.low.timeout = 5
naughty.config.presets.normal.timeout = 6
naughty.config.presets.critical.timeout = 12
