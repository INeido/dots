--       ██╗   ██╗██████╗ ████████╗██╗███╗   ███╗███████╗
--       ██║   ██║██╔══██╗╚══██╔══╝██║████╗ ████║██╔════╝
--       ██║   ██║██████╔╝   ██║   ██║██╔████╔██║█████╗
--       ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██╔══╝
--       ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║███████╗
--        ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝


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
local scripts      = { [[cat /proc/uptime | cut -d' ' -f1 | cut -d'.' -f1]] }
local interval     = 60
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local time = stdout:gsub("\n", "")

        if not tonumber(time) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "Uptime Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/uptime.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
        end

        awesome.emit_signal("evil::uptime", {
            time = time or 0,
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
