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
