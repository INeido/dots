--       ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--       ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--       ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
--       ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
--       ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--       ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


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
local scripts      = {
    "awk '/" .. settings.network_interface .. "/{print $2,$10}' /proc/net/dev",
    "awk '/wlan0/{print $2,$10}' /proc/net/dev"
}
local interval     = 0.5
local timer        = gears.timer {}

local last_down, last_up = 0, 0

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local new_down, new_up = stdout:match("(%d+)%s+(%d+)")

        if not tonumber(new_down) or not tonumber(new_up) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "Network Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/network.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
        end

        local down = (new_down - last_down) / interval
        local up = (new_up - last_up) / interval

        last_down = new_down
        last_up = new_up

        awesome.emit_signal("evil::network", {
            down = down or 0,
            up   = up or 0,
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
