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

local sp_bin = 'sp'
local GET_SPOTIFY_ART = sp_bin .. ' art'
local GET_SPOTIFY_STATUS_CMD = sp_bin .. ' status'
local GET_CURRENT_SONG_CMD = sp_bin .. ' current'

local interval = 1

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(GET_SPOTIFY_ART, interval, function(_, stdout)
    local art = stdout

    awesome.emit_signal("evil::spotify_art", {
        art = art or "",
    })
end)

awful.widget.watch(GET_SPOTIFY_STATUS_CMD, interval, function(_, stdout)
    local status = stdout

    awesome.emit_signal("evil::spotify_status", {
        status = status or "",
    })
end)

awful.widget.watch(GET_CURRENT_SONG_CMD, interval, function(_, stdout)
    local song = stdout

    awesome.emit_signal("evil::spotify_song", {
        song = song or "",
    })
end)
