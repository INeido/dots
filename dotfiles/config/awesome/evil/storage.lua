--       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
--       ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
--       ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗
--       ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝
--       ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
--       ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local dpi = require("beautiful").xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local script = "df -BK "
for _, v in ipairs(settings.drive_names) do
    script = script .. v .. " "
end
local interval = 10

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local drives = {}
    for line in stdout:gmatch("[^\r\n]+") do
        local _, size, used, free, usage, mount = line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
        if _ ~= "Filesystem" and size and used and free and usage and mount then
            table.insert(drives, {
                size = size:sub(1, -2),
                used = used:sub(1, -2),
                free = free:sub(1, -2),
                usage = usage:sub(1, -2),
                mount = mount,
            })
        end
    end

    awesome.emit_signal("evil::storage", {
        drives = drives or {},
    })
end)
