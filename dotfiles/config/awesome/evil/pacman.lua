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

local script = [[bash -c "pacman -Qu | wc -l"]]
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
