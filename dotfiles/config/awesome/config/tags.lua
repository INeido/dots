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
-- Setup Tags
-- ===================================================================

local tags = {
  {
    icon = cache.tag_icons[1],
    layout = awful.layout.suit.tile,
    selected = true,
  },
  {
    icon = cache.tag_icons[2],
    layout = awful.layout.suit.max,
  },
  {
    icon = cache.tag_icons[3],
    layout = awful.layout.suit.max,
  },
  {
    icon = cache.tag_icons[4],
    layout = awful.layout.suit.floating,
  },
}

-- ===================================================================
-- Create Tags
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
  for i, tag in pairs(tags) do
    awful.tag.add(i, {
      icon = tag.icon,
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
  if t.selected == false then
    for _, c in ipairs(t:clients()) do
      --require("naughty").notify({ title = "test", text = "test: " .. client.focus.name })
      if c.focus == true then
        cache.last_focused_client[t.index] = c
        require("naughty").notify({ title = "test", text = "de: " .. cache.last_focused_client[t.index].name })
      end
    end
  else
    if cache.last_focused_client[t.index] then
      cache.last_focused_client[t.index]:emit_signal("focus")
      require("naughty").notify({ title = "test", text = "re: " .. cache.last_focused_client[t.index].name })
    end
  end
end)
