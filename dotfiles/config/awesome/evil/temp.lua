--      ████████╗███████╗███╗   ███╗██████╗
--      ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗
--         ██║   █████╗  ██╔████╔██║██████╔╝
--         ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝
--         ██║   ███████╗██║ ╚═╝ ██║██║
--         ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝


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

local script = "bash -c \"sensors | grep 'Tctl' | awk '{print $2}' | cut -c2-3 && nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader\""
local interval = 5

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local cpu, gpu = stdout:match("(%d+)\n(%d+)")

    awesome.emit_signal("evil::temp", {
        cpu = cpu or "0",
        gpu = gpu or "0",
    })
end)
