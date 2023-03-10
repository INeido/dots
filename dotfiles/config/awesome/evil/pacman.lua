--       ██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗
--       ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║
--       ██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║
--       ██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
--       ██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
--       ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝                                                  


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

local script = "sudo " .. beautiful.config_path .. "scripts/pacman.sh check"
local interval = 600

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local count = string.gsub(stdout, "\n", "")

    awesome.emit_signal("evil::pacman", {
        count = count,
    })

end)
