--      ████████╗ █████╗ ███████╗██╗  ██╗██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║███████╗█████╔╝ ██║     ██║███████╗   ██║
--         ██║   ██╔══██║╚════██║██╔═██╗ ██║     ██║╚════██║   ██║
--         ██║   ██║  ██║███████║██║  ██╗███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful          = require("awful")
local gears          = require("gears")
local wibox          = require("wibox")
local helpers        = require("helpers")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi

-- ===================================================================
-- Buttons
-- ===================================================================

local widget_buttons = gears.table.join(
    awful.button({}, 1, nil, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 2, nil, function(c)
        c:kill()
    end),
    awful.button({}, 4, nil, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, nil, function()
        awful.client.focus.byidx(-1)
    end)
)

local pin_buttons    = gears.table.join(
    awful.button({}, 1, nil, function(c)
        if string.match(c, "^steam_app_%d+$") then
            awful.spawn("steam steam://rungameid/" .. c:match("%d+"))
        else
            awful.spawn(c)
        end
    end)
)

-- ===================================================================
-- Functions
-- ===================================================================

local function get_screen(s)
    return s and screen[s]
end

local function filter(c, screen)
    screen = get_screen(screen)
    -- Only print client on the same screen as this widget
    if get_screen(c.screen) ~= screen then
        return false
    end
    if c.sticky then
        return true
    end
    local tags = screen.tags
    for _, t in ipairs(tags) do
        if t.selected then
            local ctags = c:tags()
            for _, v in ipairs(ctags) do
                if v == t then
                    return true
                end
            end
        end
    end

    return false
end

local function create_buttons(buttons, object)
    if not buttons then
        return
    end

    local btns = {}
    for _, b in ipairs(buttons) do
        local btn = awful.button {
            modifiers = b.modifiers,
            button = b.button,
            on_press = function() b:emit_signal("press", object) end,
            on_release = function() b:emit_signal("release", object) end
        }
        btns[#btns + 1] = btn
    end
    return btns
end

local function create_entry(btns, object)
    local icon      = wibox.widget {
        {
            id     = "icon",
            resize = true,
            widget = wibox.widget.imagebox,
        },
        margins = dpi(6),
        expand  = true,
        widget  = wibox.container.margin,
    }

    local indicator = wibox.widget {
        {
            id            = "indicator",
            forced_height = dpi(3),
            widget        = wibox.container.background,
        },
        expand = true,
        widget = wibox.container.margin,
    }

    local entry     = wibox.widget {
        {
            {
                icon,
                indicator,
                spacing = dpi(2),
                layout = wibox.layout.fixed.vertical,
            },
            height = beautiful.bar_height - dpi(6),
            widget = wibox.container.constraint,
        },
        bg     = beautiful.widget_normal,
        widget = wibox.container.background,
    }

    local pin       = type(object) == "string"

    -- Set icon
    if not pin then
        icon.icon.image = helpers.find_icon(nil, object)
    else
        icon.icon.image = helpers.find_icon(object, nil)
    end

    -- Set color
    if not pin then
        if object.minimized then
            entry.bg = beautiful.widget_normal
            indicator.indicator.bg = beautiful.accent
        elseif object.urgent then
            entry.bg = beautiful.widget_normal
            indicator.indicator.bg = beautiful.widget_urgent
        elseif object == client.focus then
            entry.bg = beautiful.widget_selected
            indicator.indicator.bg = beautiful.accent
        else
            entry.bg = beautiful.widget_normal
            indicator.indicator.bg = beautiful.accent
        end
    end

    -- Set indicator size
    if not pin then
        if object.minimized then
            indicator.left  = dpi(8)
            indicator.right = dpi(8)
        else
            indicator.left  = 0
            indicator.right = 0
        end
    end

    entry:buttons(create_buttons(btns, object))

    entry:connect_signal("mouse::enter", function()
        if object ~= client.focus or pin then
            entry.bg = beautiful.widget_hover
        else
            entry.bg = beautiful.widget_hover
        end
    end)

    entry:connect_signal("mouse::leave", function()
        if object ~= client.focus or pin then
            entry.bg = beautiful.widget_normal
        else
            entry.bg = beautiful.widget_selected
        end
    end)

    entry:connect_signal("button::press", function()
        if object ~= client.focus or pin then
            entry.bg = beautiful.widget_hover .. "DD"
        else
            entry.bg = beautiful.widget_hover .. "DD"
        end
    end)

    entry:connect_signal("button::release", function()
        if object ~= client.focus or pin then
            entry.bg = beautiful.widget_normal
        else
            entry.bg = beautiful.widget_selected
        end
    end)

    return entry
end

-- ===================================================================
-- Taglist
-- ===================================================================

local function tasklist(s)
    local function update(w, buttons, label, data, objects, metadata)
        w:reset()
        w:set_spacing(dpi(6))

        local classnames = {}

        -- Add running clients
        for _, object in ipairs(objects) do
            table.insert(classnames, string.lower(object.class))
            w:add(create_entry(widget_buttons, object))
        end

        -- Add pinned clients
        local tags = s.tags
        for _, t in ipairs(tags) do
            if t.selected then
                for _, object in ipairs(settings.tags[t.index].pinned) do
                    if not string.find(table.concat(classnames, ", "), object:gsub("-", "%%-")) then
                        w:insert(1, create_entry(pin_buttons, object))
                    end
                end
            end
        end

        return w
    end

    return awful.widget.tasklist(
        s,
        filter,
        {},
        {},
        update,
        wibox.layout.fixed.horizontal()
    )
end

return tasklist
