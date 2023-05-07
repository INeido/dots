--      ████████╗ █████╗  ██████╗ ███████╗
--      ╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝
--         ██║   ███████║██║  ███╗███████╗
--         ██║   ██╔══██║██║   ██║╚════██║
--         ██║   ██║  ██║╚██████╔╝███████║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")

-- ===================================================================
-- Create Tags
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
  for i, tag in pairs(settings.tags) do
    awful.tag.add(i, {
      icon = cache.tag_icons[i],
      icon_only = true,
      layout = tag.layout,
      screen = s,
      selected = tag.selected
    })
  end
end)

-- ===================================================================
-- Signal
-- ===================================================================

-- Focus last client when switching tags
tag.connect_signal("property::selected", function(t)
  if t.selected == true then
    client.focus = cache.client_focus[t.index]
  end
end)
