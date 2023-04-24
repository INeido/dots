--      ████████╗███████╗███╗   ███╗██████╗
--      ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗
--         ██║   █████╗  ██╔████╔██║██████╔╝
--         ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝
--         ██║   ███████╗██║ ╚═╝ ██║██║
--         ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")

-- ===================================================================
-- Variables
-- ===================================================================

local script = [[bash -c "sensors | grep 'Tctl' | awk '{print $2}' | cut -c2-3"]]
local interval = 5

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local cpu = stdout:gsub("\n", "")

    awesome.emit_signal("evil::temp", {
        cpu = cpu or 0,
    })

    collectgarbage("collect")
end)
