--      ████████╗███████╗███╗   ███╗██████╗
--      ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗
--         ██║   █████╗  ██╔████╔██║██████╔╝
--         ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝
--         ██║   ███████╗██║ ╚═╝ ██║██║
--         ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝


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
local scripts      = { [[sensors | grep 'Tctl' | awk '{print $2}' | cut -c2-3]], -- Works on my main system
    [[sensors | grep 'Core 0:' | awk '{print $3}' | cut -c2-3]] }                 -- Works on old radeon laptop
local interval     = 5
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local cpu = stdout:gsub("\n", "")

        if not tonumber(cpu) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "Temp Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/temp.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
        end

        awesome.emit_signal("evil::temp", {
            cpu = cpu or 0,
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
