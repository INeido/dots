--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("config.keys")

-- ===================================================================
-- Rules
-- ===================================================================

rules = {
  -- All clients will match this rule.
  { rule = {},
    properties = { border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false
    }
  },

  -- Add titlebars to normal clients and dialogs
  { rule_any = { type = { "normal", "dialog" } },
    properties = {
      titlebars_enabled = true
    }
  },

  -- Application rules
  { rule = { class = "Firefox" },
    properties = {
      maximized = true
    },
  },
  { rule = { class = "Dolphin" },
    properties = { floating = true },
    callback = function(c)
      awful.placement.centered(c, nil)
    end
  },
  { rule = { class = "Spotify" },
    properties = {
      maximized = true
    },
  },
  { rule = { class = "Steam" },
    properties = {
      titlebars_enabled = false,
      minimized = true
    },
  }
}

awful.rules.rules = rules
