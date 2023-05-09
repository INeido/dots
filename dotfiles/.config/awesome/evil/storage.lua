--       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
--       ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
--       ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗
--       ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝
--       ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
--       ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝


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
local scripts      = { [[df -BK]] }
local interval     = 60
local timer        = gears.timer {}

-- ===================================================================
-- Daemon
-- ===================================================================

local function try_script()
    awful.spawn.easy_async_with_shell(scripts[script_index], function(stdout)
        local drives = {}
        for line in stdout:gmatch("[^\r\n]+") do
            local fs, size, used, free, usage, mount = line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
            -- Skip first line (header)
            if fs ~= "Filesystem" and size and used and free and usage and mount then
                table.insert(drives, {
                    fs    = fs,
                    size  = size:sub(1, -2),
                    used  = used:sub(1, -2),
                    free  = free:sub(1, -2),
                    usage = usage:sub(1, -2),
                    mount = mount,
                })
            end
        end

        if not tonumber(drives[1].size) or not tonumber(drives[1].used) or not tonumber(drives[1].free) or not tonumber(drives[1].usage) then
            -- Invalid output, try next script
            script_index = script_index + 1
            if script_index > #scripts then
                -- All scripts have been tried, stop the timer
                timer:stop()

                naughty.notification({
                    app_name = "Storage Daemon",
                    urgency = "critical",
                    title = "Daemon stopped",
                    text =
                        "Couldn't get a proper reading. None of the scripts worked. You can find the scripts under " ..
                        os.getenv("HOME") .. "/.config/awesome/evil/storage.lua and try to fix it.",
                })
                return
            end

            -- Try the next script
            timer:again()
            return
        end

        awesome.emit_signal("evil::storage", {
            drives = drives or {},
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
