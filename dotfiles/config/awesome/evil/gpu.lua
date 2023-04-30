--         ██████╗ ██████╗ ██╗   ██╗
--        ██╔════╝ ██╔══██╗██║   ██║
--        ██║  ███╗██████╔╝██║   ██║
--        ██║   ██║██╔═══╝ ██║   ██║
--        ╚██████╔╝██║     ╚██████╔╝
--         ╚═════╝ ╚═╝      ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful    = require("awful")

-- ===================================================================
-- Variables
-- ===================================================================

local script   =
"nvidia-smi --query-gpu=clocks.sm,utilization.gpu,temperature.gpu,memory.total,memory.used --format=csv,noheader,nounits"
local interval = 2

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local clock, util, temp, ram_total, ram_used = stdout:match("(%d+), (%d+), (%d+), (%d+), (%d+)")
    local ram_usage = math.floor(ram_used / ram_total * 100)

    awesome.emit_signal("evil::gpu", {
        clock     = clock or 0,
        util      = util or 0,
        temp      = temp or 0,
        ram_total = ram_total or 0,
        ram_used  = ram_used or 0,
        ram_usage = ram_usage or 0,
    })

    collectgarbage("collect")
end)
