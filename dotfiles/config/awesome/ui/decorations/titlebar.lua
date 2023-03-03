--      ████████╗██╗████████╗██╗     ███████╗██████╗  █████╗ ██████╗
--      ╚══██╔══╝██║╚══██╔══╝██║     ██╔════╝██╔══██╗██╔══██╗██╔══██╗
--         ██║   ██║   ██║   ██║     █████╗  ██████╔╝███████║██████╔╝
--         ██║   ██║   ██║   ██║     ██╔══╝  ██╔══██╗██╔══██║██╔══██╗
--         ██║   ██║   ██║   ███████╗███████╗██████╔╝██║  ██║██║  ██║
--         ╚═╝   ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


-- ===================================================================
-- Initialization
-- ===================================================================

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Create Button
-- ===================================================================

local function create_button(command, c)
    local w = wibox.widget {
            {
                {
                    {
                        widget = wibox.widget.textbox,
                    },
                    forced_height = dpi(15),
                    forced_width = dpi(15),
                    shape = gears.shape.circle,
                    bg = beautiful.titlebar_button_normal,
                    widget = wibox.container.background,
                },
                margins = 5,
                widget = wibox.container.margin,
            },
            widget = wibox.container.background,
        }

    -- Hover effect
    w:connect_signal("mouse::enter", function()
        w.children[1].children[1].bg = beautiful.titlebar_button_normal_hover
    end)
    w:connect_signal("mouse::leave", function()
        --require("naughty").notify({ title = "Achtung!", text = text, timeout = 0 })
        w.children[1].children[1].bg = beautiful.titlebar_button_normal
    end)

    -- Press effect
    w:connect_signal("button::press", function()
        w.children[1].children[1].bg = beautiful.titlebar_button_normal
    end)
    w:connect_signal("button::release", function()
        w.children[1].children[1].bg = beautiful.titlebar_button_normal
    end)

    -- Button action
    w:buttons(gears.table.join(w:buttons(), awful.button({}, 1, nil, command)))

    return w
end

-- ===================================================================
-- Double Click
-- ===================================================================

local last_click_time = 0
local function leftclick(c)
    local current_time = os.time()
    if current_time - last_click_time < 0.2 then
        c.maximized = not c.maximized
    else
        last_click_time = current_time
        client.focus = c
        awful.mouse.client.move(c)
        c:raise()
    end
end

-- ===================================================================
-- Build
-- ===================================================================

return function(c)
    local buttons = gears.table.join(
            awful.button({}, 1, function()
                leftclick(c)
            end),
            awful.button({}, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
        )

    local left = {
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal,
    }

    local middle = {
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal,
    }

    local right = {
        {
            create_button(function()
                c.minimized = true
            end, c),

            create_button(function()
                c.maximized = not c.maximized
                c:raise()
            end, c),

            create_button(function()
                c:kill()
            end, c),

            layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin
    }

    return {
        {
            left,
            middle,
            right,
            layout = wibox.layout.align.horizontal,
        },
        widget = wibox.container.background,
    }
end
