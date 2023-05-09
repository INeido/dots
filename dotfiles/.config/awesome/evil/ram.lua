--      ██████╗  █████╗ ███╗   ███╗
--      ██╔══██╗██╔══██╗████╗ ████║
--      ██████╔╝███████║██╔████╔██║
--      ██╔══██╗██╔══██║██║╚██╔╝██║
--      ██║  ██║██║  ██║██║ ╚═╝ ██║
--      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝


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
    [[free -m | awk '/^Mem/ {printf "%d", $2}'; printf "\n" && free -m | awk '/^Mem/ {printf "%d", $3}'; printf "\n" && free -m | awk '/^Mem/ {printf "%d", $4}'; printf "\n" && free -m | awk '/^Mem/ {printf "%d", $7}']] }
local interval     = 2
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local total, used, free, available = stdout:match("(%d+)\n(%d+)\n(%d+)\n(%d+)")

        if not tonumber(total) or not tonumber(used) or not tonumber(free) or not tonumber(available) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "RAM Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/ram.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
        end

        total       = string.format("%.0f", tonumber(total))
        used        = string.format("%.0f", tonumber(used))
        free        = string.format("%.0f", tonumber(free))
        available   = string.format("%.0f", tonumber(available))
        local usage = math.floor(used / total * 100)

        awesome.emit_signal("evil::ram", {
            total     = total or 0,
            used      = used or 0,
            free      = free or 0,
            available = available or 0,
            usage     = usage or 0,
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
