--        ██████╗██████╗ ██╗   ██╗
--       ██╔════╝██╔══██╗██║   ██║
--       ██║     ██████╔╝██║   ██║
--       ██║     ██╔═══╝ ██║   ██║
--       ╚██████╗██║     ╚██████╔╝
--        ╚═════╝╚═╝      ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful    = require("awful")

-- ===================================================================
-- Variables
-- ===================================================================

local script   = [[awk '$1~/cpu[0-9]/{usage=($2+$4)*100/($2+$4+$5); printf "%.2f\n", usage}' /proc/stat]]
local interval = 2

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local cores = {}
    for core in stdout:gmatch("[^\r\n]+") do
        table.insert(cores, core)
    end

    local sum = 0
    for i = 1, #cores do
        sum = sum + cores[i]
    end

    local util = string.format("%.1f", sum / #cores)

    awesome.emit_signal("evil::cpu", {
        cores = cores or { 0 },
        util = util or 0,
    })

    collectgarbage("collect")
end)
