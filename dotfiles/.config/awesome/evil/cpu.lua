--        ██████╗██████╗ ██╗   ██╗
--       ██╔════╝██╔══██╗██║   ██║
--       ██║     ██████╔╝██║   ██║
--       ██║     ██╔═══╝ ██║   ██║
--       ╚██████╗██║     ╚██████╔╝
--        ╚═════╝╚═╝      ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local gears        = require("gears")
local awful        = require("awful")
local naughty      = require("naughty")

-- ===================================================================
-- Variables
-- ===================================================================

local script_index = 1
local scripts      = { [[awk '$1~/cpu[0-9]/{usage=($2+$4)*100/($2+$4+$5); printf "%.2f\n", usage}' /proc/stat]] }
local interval     = 2
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local cores = {}
        for core in stdout:gmatch("[^\r\n]+") do
            table.insert(cores, core)
        end

        if not tonumber(cores[1]) or not tonumber(cores[#cores]) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "CPU Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/cpu.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
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
