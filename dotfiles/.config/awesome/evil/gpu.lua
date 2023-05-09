--         ██████╗ ██████╗ ██╗   ██╗
--        ██╔════╝ ██╔══██╗██║   ██║
--        ██║  ███╗██████╔╝██║   ██║
--        ██║   ██║██╔═══╝ ██║   ██║
--        ╚██████╔╝██║     ╚██████╔╝
--         ╚═════╝ ╚═╝      ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local gears    = require("gears")
local awful    = require("awful")
local naughty  = require("naughty")

-- ===================================================================
-- Variables
-- ===================================================================

local script   =
[[nvidia-smi --query-gpu=clocks.sm,utilization.gpu,temperature.gpu,memory.total,memory.used --format=csv,noheader,nounits]]
local interval = 2
local timer    = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(script, function(stdout)
        local clock, util, temp, ram_total, ram_used = stdout:match("(%d+), (%d+), (%d+), (%d+), (%d+)")

        if not tonumber(clock) or not tonumber(util) or not tonumber(temp) or not tonumber(ram_total) or not tonumber(ram_used) then
            timer:stop()

            naughty.notification({
                app_name = "GPU Daemon",
                urgency = "critical",
                title = "Daemon stopped",
                text =
                    "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                    os.getenv("HOME") .. "/.config/awesome/evil/gpu.lua and try to fix it.",
            })
            return
        end

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
end

-- ===================================================================
-- Timer
-- ===================================================================

timer = gears.timer {
    timeout   = interval,
    call_now  = true,
    autostart = true,
    callback  = try_script
}
