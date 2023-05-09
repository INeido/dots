--      ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
--      ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
--      ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝
--      ██╔══██╗██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝
--      ██████╔╝██║  ██║   ██║      ██║   ███████╗██║  ██║   ██║
--      ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝


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
local scripts      = { [[upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}']] }
local interval     = 10
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local percentage = stdout:gsub("\n", "")

        if not tonumber(percentage) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "Battery Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/battery.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
        end

        awesome.emit_signal("evil::battery", {
            percentage = percentage or 0,
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
