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

local script = [[bash -c "free -m | awk '/^Mem/ {printf \"%d\", \$2}'; printf \"\n\" && free -m | awk '/^Mem/ {printf \"%d\", \$3}'; printf \"\n\" && free -m | awk '/^Mem/ {printf \"%d\", \$4}'"]]
local interval = 1

-- ===================================================================
-- Daemon
-- ===================================================================

awful.widget.watch(script, interval, function(_, stdout)
    local total, used, free = stdout:match("(%d+)\n(%d+)\n(%d+)")

    total = string.format("%.0f", tonumber(total))
    used = string.format("%.0f", tonumber(used))
    free = string.format("%.0f", tonumber(free))
    local usage = math.floor(used / total * 100)

    awesome.emit_signal("evil::ram", {
        total = total or 0,
        used = used or 0,
        free = free or 0,
        usage = usage or 0,
    })
end)
