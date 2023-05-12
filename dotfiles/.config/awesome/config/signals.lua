--      ███████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██╗     ███████╗
--      ██╔════╝██║██╔════╝ ████╗  ██║██╔══██╗██║     ██╔════╝
--      ███████╗██║██║  ███╗██╔██╗ ██║███████║██║     ███████╗
--      ╚════██║██║██║   ██║██║╚██╗██║██╔══██║██║     ╚════██║
--      ███████║██║╚██████╔╝██║ ╚████║██║  ██║███████╗███████║
--      ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local wibox     = require("wibox")
local helpers   = require("helpers")
local naughty   = require("naughty")
local beautiful = require("beautiful")

-- ===================================================================
-- Signals
-- ===================================================================

-- Fix, for when your monitor turns off and loses its settings
screen.connect_signal("list", function() awful.spawn.with_shell(settings.display) end)

screen.connect_signal("request::wallpaper", function(args)
    -- This breaks the normal requests, but I think its inevitable here
    if args.id then
        awful.wallpaper {
            screen = args.s,
            widget = {
                image = cache.wallpapers[args.s.index][args.id].normal,
                resize = false,
                widget = wibox.widget.imagebox,
            }
        }
    end
end)

naughty.connect_signal("request::display", function(n)
    -- Add destroyed notifications to the bulletin
    n:connect_signal("destroyed", function(self, reason, keep_visible)
        -- Timeout
        if reason == 1 then
            add_notification(n)
            -- User dismissed
        elseif reason == 2 then
            helpers.jump_to_client(n.clients[1])
        end
    end)

    -- Display the notification using the default implementation
    if bu_get_visibility() == false and not settings.do_not_disturb then
        naughty.layout.box { notification = n, widget_template = require("ui.widgets.bulletin.not_template")(n) }
        naughty.layout.box.buttons = nil
    else
        n:destroy(1)
    end
end)

-- Client decorations
client.connect_signal("request::titlebars", function(c) add_decorations(c) end)

-- Client border color
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Enable sloppy focus, so that focus follows mouse
if settings.sloppy_focus == true then
    client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end)
end

-- Prevent clients from going offscreen
client.connect_signal("request::manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Save last two focused clients
client.connect_signal("focus", function(c)
    local tag = c.first_tag or nil
    if tag then
        if cache.client_focus[tag.index] then
            cache.client_focus_lost[tag.index] = cache.client_focus[tag.index]
        end
        cache.client_focus[tag.index] = c
    end
end)

-- Focus the last client if the current one got closed
client.connect_signal("untagged", function(c)
    local prev_client = awful.client.focus.history.get(c.screen, 0)
    if prev_client then
        local tag = prev_client.first_tag or nil
        if tag then
            cache.client_focus[tag.index] = prev_client
            local focus = cache.client_focus_lost[tag.index]
            if focus then
                if focus.valid then
                    if not focus.minimized then
                        client.focus = focus
                        focus:raise()
                    end
                end
            end
        end
    end
end)

-- Focus the last client if the current one got minimized
client.connect_signal("property::minimized", function(c)
    if c.minimized == true then
        local tag = c.first_tag or nil
        if tag then
            local focus = cache.client_focus_lost[tag.index]
            if focus then
                if focus.valid then
                    if not focus.minimized then
                        client.focus = focus
                        focus:raise()
                    end
                end
            end
        end
    end
end)

-- Focus last client when switching tags
tag.connect_signal("property::selected", function(t)
    if t.selected == true then
        local focus = cache.client_focus[t.index]
        if focus then
            if focus.valid then
                if not focus.minimized then
                    client.focus = focus
                    focus:raise()
                end
            end
        end
    end
end)