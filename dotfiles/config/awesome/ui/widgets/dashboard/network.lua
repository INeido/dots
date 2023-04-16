--       ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--       ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--       ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
--       ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
--       ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--       ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


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
-- Functions
-- ===================================================================

local function format_traffic(val)
  local bytes = val / 1024
  if bytes > 1024 ^ 3 then
    return string.format("%.2f GB/s", bytes / 1024 ^ 3)
  elseif bytes > 1024 ^ 2 then
    return string.format("%.2f MB/s", bytes / 1024 ^ 2)
  elseif bytes > 1024 then
    return string.format("%.2f KB/s", bytes / 1024)
  else
    return string.format("%.0f B/s", bytes)
  end
end

-- ===================================================================
-- Widget
-- ===================================================================

local w = wibox.widget {
  -- Horizontal Layout
  {
    -- Horizontal Layout
    {
      -- Margin
      {
        -- Download Icon
        id = "downloadicon",
        resize = true,
        image = gears.color.recolor_image(beautiful.config_path .. "/icons/download.svg", beautiful.accent),
        widget = wibox.widget.imagebox,
      },
      top = dpi(30),
      bottom = dpi(30),
      widget = wibox.container.margin,
    },
    {
      -- Download Text
      id = "downloadtext",
      font = beautiful.font .. "Bold 18",
      widget = wibox.widget.textbox,
    },
    spacing = dpi(3),
    layout = wibox.layout.fixed.horizontal,
  },
  {
    -- Horizontal Layout
    {
      -- Margin
      {
        -- Upload Icon
        id = "uploadicon",
        resize = true,
        image = gears.color.recolor_image(beautiful.config_path .. "/icons/upload.svg", beautiful.accent),
        widget = wibox.widget.imagebox,
      },
      top = dpi(30),
      bottom = dpi(30),
      widget = wibox.container.margin,
    },
    {
      -- Upload Text
      id = "uploadtext",
      font = beautiful.font .. "Bold 18",
      widget = wibox.widget.textbox,
    },
    spacing = dpi(3),
    layout = wibox.layout.fixed.horizontal,
  },
  spacing = dpi(15),
  layout = wibox.layout.fixed.horizontal,
}

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::network", function(args)
  w:get_children_by_id("downloadtext")[1]:set_text(format_traffic(args.down))
  w:get_children_by_id("uploadtext")[1]:set_text(format_traffic(args.up))
end)

return w
