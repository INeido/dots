--       ██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗
--       ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║
--       ██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║
--       ██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
--       ██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
--       ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful    = require("awful")

-- ===================================================================
-- Variables
-- ===================================================================

local script   = [[bash -c "checkupdates"]]
local interval = 600

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local packages = {}

    for val in stdout:gmatch("([^\n]+)") do
        if val ~= nil then
            table.insert(packages, val)
        end
    end

    awesome.emit_signal("evil::pacman", {
        packages = packages or {}
    })

    collectgarbage("collect")
end)