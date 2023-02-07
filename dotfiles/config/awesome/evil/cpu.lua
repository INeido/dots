--        ██████╗██████╗ ██╗   ██╗
--       ██╔════╝██╔══██╗██║   ██║
--       ██║     ██████╔╝██║   ██║
--       ██║     ██╔═══╝ ██║   ██║
--       ╚██████╗██║     ╚██████╔╝
--        ╚═════╝╚═╝      ╚═════╝


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

local script = [[bash -c "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf \"%.0f%%\", usage}'"]]
local interval = 1

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local avg = string.gsub(stdout, "\n", "")

    awesome.emit_signal("evil::cpu", {
        avg = avg,
    })

end)
