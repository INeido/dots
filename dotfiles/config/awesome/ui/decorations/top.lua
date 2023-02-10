--      ████████╗ ██████╗ ██████╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗
--         ██║   ██║   ██║██████╔╝
--         ██║   ██║   ██║██╔═══╝
--         ██║   ╚██████╔╝██║
--         ╚═╝    ╚═════╝ ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- ===================================================================
-- Top
-- ===================================================================

return function(c, args)
    if beautiful.switch_titlebar then
        awful.titlebar(c):setup(require("ui.decorations.titlebar")(c))
    end
end
