--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful       = require("awful")
local helpers     = require("helpers")
local beautiful   = require("beautiful")

local screen      = awful.screen.focused()

-- ===================================================================
-- Rules
-- ===================================================================

awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width     = beautiful.border_width,
      border_color     = beautiful.border_normal,
      focus            = awful.client.focus.filter,
      raise            = true,
      screen           = awful.screen.preferred,
      placement        = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false,
    }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any   = { type = { "normal", "dialog" } },
    properties = {
      titlebars_enabled = settings.enable_titlebar,
    }
  },

  -- Application rules
  {
    rule       = { class = helpers.capitalize(settings.fileexplorer) },
    properties = {
      floating = true
    },
    callback   = function(c)
      awful.placement.centered(c, nil)
    end
  },
  {
    rule       = { class = helpers.capitalize(settings.terminal) },
    properties = {
      floating = true
    },
    callback   = function(c)
      awful.placement.centered(c, nil)
    end
  },
  {
    rule       = { class = helpers.capitalize(settings.musicplayer) },
    properties = {
      floating     = true,
      sticky       = true,
      ontop        = true,
      maximized    = true,
      minimized    = true,
      skip_taskbar = true,
    },
  },
  {
    rule       = { class = "Steam" },
    properties = {
      titlebars_enabled = false,
      tag = screen.tags[2]
    },
  },
  {
    rule       = { class = "Discord" },
    properties = {
      tag = screen.tags[1]
    },
  }
}
