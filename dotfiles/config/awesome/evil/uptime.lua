--       ██╗   ██╗██████╗ ████████╗██╗███╗   ███╗███████╗
--       ██║   ██║██╔══██╗╚══██╔══╝██║████╗ ████║██╔════╝
--       ██║   ██║██████╔╝   ██║   ██║██╔████╔██║█████╗  
--       ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██╔══╝  
--       ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║███████╗
--        ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝


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

local script = [[bash -c "cat /proc/uptime | cut -d' ' -f1 | cut -d'.' -f1"]]
local interval = 5

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local time = stdout:gsub("\n", "")

    awesome.emit_signal("evil::uptime", {
        time = time or 0,
    })
end)
