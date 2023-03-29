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
local dpi = require("beautiful").xresources.apply_dpi

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
    if status == " " then status = nil end
    awful.spawn.easy_async_with_shell(script_position, function(pos)
        local position = pos:gsub("%s+", "")
        if position == " " then position = nil end
        awful.spawn.easy_async_with_shell(script_volume, function(vol)
            local volume = vol:gsub("%s+", "")
            if volume == " " then volume = nil end
            awful.spawn.easy_async_with_shell(script_metadata, function(data)
                local metadata = {}

                for line in data:gmatch("[^\r\n]+") do
                    local key, value = line:match("^%s*spotify%s+(%S+)%s+(.+)$")
                    key = key:gsub("^.-%:", "")
                    if key and value then
                        if value == " " then metadata[key:lower()] = nil  else metadata[key:lower()] = value end
                    end
                end

                awesome.emit_signal("evil::spotify", {
                    status = status or nil,
                    position = position or nil,
                    volume = volume or nil,
                    length = metadata.length or nil,
                    album = metadata.album or nil,
                    artist = metadata.artist or nil,
                    title = metadata.title or nil,
                    art = metadata.arturl or nil,
                })
            end)
        end)
    end)
end)
