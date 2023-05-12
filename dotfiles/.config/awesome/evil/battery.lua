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
local scripts      = { [[
    upower -i $(upower -e | grep BAT) | awk '/state:/ { state = $2 } /percentage:/ { percentage = $2 } /time to full:/ { time_to_full = $4 " " $5 } END { print state "," percentage "," time_to_full }']] }
local interval     = 10
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local result = {}
        for value in stdout:gmatch("([^,]+)") do
            if value then
                table.insert(result, value)
            end
        end

        if #result < 2 then
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

        local state = result[1]
        local percentage = result[2]:gsub("%%", "")
        local time_to_full = result[3]

        awesome.emit_signal("evil::battery", {
            percentage = percentage or 0,
            state = state or nil,
            time_to_full = time_to_full or nil,
        })

        collectgarbage("collect")
    end)
end

-- ===================================================================
-- Timer
-- ===================================================================

if settings.laptop_mode then
    timer = gears.timer {
        timeout   = interval,
        call_now  = true,
        autostart = true,
        callback  = try_script
    }
end
