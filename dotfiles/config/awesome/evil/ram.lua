--      ██████╗  █████╗ ███╗   ███╗
--      ██╔══██╗██╔══██╗████╗ ████║
--      ██████╔╝███████║██╔████╔██║
--      ██╔══██╗██╔══██║██║╚██╔╝██║
--      ██║  ██║██║  ██║██║ ╚═╝ ██║
--      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")

-- ===================================================================
-- Variables
-- ===================================================================

local script = [[bash -c "free -m | awk '/^Mem/ {printf \"%d\", \$2}'; printf \"\n\" && free -m | awk '/^Mem/ {printf \"%d\", \$3}'; printf \"\n\" && free -m | awk '/^Mem/ {printf \"%d\", \$4}'; printf \"\n\" && free -m | awk '/^Mem/ {printf \"%d\", \$7}'"]]
local interval = 2

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local total, used, free, available = stdout:match("(%d+)\n(%d+)\n(%d+)\n(%d+)")

    total = string.format("%.0f", tonumber(total))
    used = string.format("%.0f", tonumber(used))
    free = string.format("%.0f", tonumber(free))
    available = string.format("%.0f", tonumber(available))
    local usage = math.floor(used / total * 100)

    awesome.emit_signal("evil::ram", {
        total = total or 0,
        used = used or 0,
        free = free or 0,
        available = available or 0,
        usage = usage or 0,
    })

    collectgarbage("collect")
end)
