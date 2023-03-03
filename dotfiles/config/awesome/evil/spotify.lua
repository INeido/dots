--      ███████╗██████╗  ██████╗ ████████╗██╗███████╗██╗   ██╗
--      ██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║██╔════╝╚██╗ ██╔╝
--      ███████╗██████╔╝██║   ██║   ██║   ██║█████╗   ╚████╔╝
--      ╚════██║██╔═══╝ ██║   ██║   ██║   ██║██╔══╝    ╚██╔╝
--      ███████║██║     ╚██████╔╝   ██║   ██║██║        ██║
--      ╚══════╝╚═╝      ╚═════╝    ╚═╝   ╚═╝╚═╝        ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local dpi = require('beautiful').xresources.apply_dpi

-- ===================================================================
-- Variables
-- ===================================================================

local script_metadata = "playerctl -p spotify metadata"
local script_status = "playerctl -p spotify status"
local script_position = "playerctl -p spotify position"
local script_volume = "playerctl -p spotify volume"

local interval = 0.1

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script_status, interval, function(_, stat)
    local status = stat:gsub("%s+", "")
    awful.spawn.easy_async_with_shell(script_position, function(pos)
        local position = pos:gsub("%s+", "")
        awful.spawn.easy_async_with_shell(script_volume, function(vol)
            local volume = vol:gsub("%s+", "")
            awful.spawn.easy_async_with_shell(script_metadata, function(data)
                local metadata = {}

                for line in data:gmatch("[^\r\n]+") do
                    local key, value = line:match("^%s*spotify%s+(%S+)%s+(.+)$")
                    key = key:gsub("^.-%:", "")
                    if key and value then
                        metadata[key:lower()] = value
                    end
                end

                awesome.emit_signal("evil::spotify", {
                    status = status or "",
                    position = position or 0,
                    volume = volume or 0,
                    length = metadata.length or 0,
                    album = metadata.album or "",
                    artist = metadata.artist or "",
                    title = metadata.title or "",
                    art = metadata.arturl or "",
                })
            end)
        end)
    end)
end)
