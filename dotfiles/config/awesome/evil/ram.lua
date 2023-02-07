--      ██████╗  █████╗ ███╗   ███╗
--      ██╔══██╗██╔══██╗████╗ ████║
--      ██████╔╝███████║██╔████╔██║
--      ██╔══██╗██╔══██║██║╚██╔╝██║
--      ██║  ██║██║  ██║██║ ╚═╝ ██║
--      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local dpi = require('beautiful').xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local script = [[bash -c "free | awk '/Mem/ {printf \"%.1fGB\", $3 / 1024 / 1024}'"]]
local interval = 2

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local used = string.gsub(stdout, "\n", "")

    awesome.emit_signal("evil::ram", {
        used = used,
    })

end)
