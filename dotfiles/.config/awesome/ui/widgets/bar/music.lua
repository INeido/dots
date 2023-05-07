--      ███╗   ███╗██╗   ██╗███████╗██╗ ██████╗
--      ████╗ ████║██║   ██║██╔════╝██║██╔════╝
--      ██╔████╔██║██║   ██║███████╗██║██║
--      ██║╚██╔╝██║██║   ██║╚════██║██║██║
--      ██║ ╚═╝ ██║╚██████╔╝███████║██║╚██████╗
--      ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful     = require("awful")
local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- ===================================================================
-- Helper
-- ===================================================================

local function show_player()
    local clients = client.get()
    for _, c in pairs(clients) do
        if c.class == settings.musicplayer or c.class == helpers.capitalize(settings.musicplayer) then
            c.minimized = not c.minimized
            return
        end
    end
end

local function hide_player()
    local clients = client.get()
    for _, c in pairs(clients) do
        if c.class == settings.musicplayer or c.class == helpers.capitalize(settings.musicplayer) then
            c.minimized = true
            return
        end
    end
end

-- ===================================================================
-- Variables
-- ===================================================================

local dim_opacity = 0.75

local cur_artist  = nil
local cur_title   = nil
local cur_album   = nil
local running     = false

-- ===================================================================
-- Player
-- ===================================================================

local w           = wibox.widget {
    -- Margins
    {
        {
            -- Icon
            font   = beautiful.iconfont .. "11",
            markup = helpers.text_color(" ", beautiful.accent),
            valign = "center",
            align  = "center",
            widget = wibox.widget.textbox,
        },
        {
            {
                -- Title Text
                {
                    id     = "titlew",
                    text   = "Nothing playing",
                    font   = beautiful.font .. "11",
                    widget = wibox.widget.textbox
                },
                speed         = 40,
                max_size      = dpi(160),
                step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                layout        = wibox.container.scroll.horizontal,
            },
            {
                -- Connector betwee Title and Artist
                id     = "connectorw",
                text   = " - ",
                font   = beautiful.font .. "11",
                widget = wibox.widget.textbox,
            },
            {
                -- Artist Text
                id     = "artistw",
                text   = "wub wub",
                font   = beautiful.font .. "11",
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.align.horizontal,
        },
        spacing = dpi(2),
        layout  = wibox.layout.fixed.horizontal,
    },
    left       = dpi(5),
    right      = dpi(5),
    widget     = wibox.container.margin,

    set_status = function(self, is_playing)
        self:get_children_by_id("titlew")[1]:emit_signal("widget::redraw_needed")

        self:get_children_by_id("titlew")[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id("titlew")[1]:emit_signal("widget::redraw_needed")

        self:get_children_by_id("artistw")[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id("artistw")[1]:emit_signal("widget::redraw_needed")
    end,

    set_text   = function(self, title, artist)
        local title_to_display = title
        if self:get_children_by_id("titlew")[1]:get_text() ~= title_to_display then
            self:get_children_by_id("titlew")[1]:set_text(title_to_display)
        end
        local artist_to_display = artist
        if self:get_children_by_id("artistw")[1]:get_text() ~= artist_to_display then
            self:get_children_by_id("artistw")[1]:set_text(artist_to_display)
        end
    end
}

-- Box the Widget
local music       = helpers.box_ba_widget(w, true, 2)

-- ===================================================================
-- Tooltip
-- ===================================================================

local tooltip     = awful.tooltip {
    objects             = { music },
    font                = beautiful.font .. "11",
    mode                = "outside",
    align               = "right",
    preferred_positions = { "right", "left", "bottom" }
}

-- ===================================================================
-- Actions
-- ===================================================================

local update      = function(widget, args, _, _, _)
    -- Update status
    widget:set_status(args.status == "Playing" and true or false)

    -- Update running
    if args.status ~= "Playing" and args.status ~= "Paused" then
        running = false
        widget:set_text("Click to open", helpers.capitalize(settings.musicplayer) .. " not running")
        return
    end
    running = true

    -- Catch podcast
    if args.artist == nil and args.album ~= nil and args.title ~= nil then
        cur_artist = args.album -- Podcasts are whack. The artist is under the 'album' metadata
        cur_title  = args.title

        widget:set_text(cur_title, cur_artist)
        widget:set_visible(true)
    end

    -- Update text
    if args.artist ~= nil and args.title ~= nil and args.album ~= nil then
        cur_artist = args.artist
        cur_title  = args.title
        cur_album  = args.album

        widget:set_text(cur_title, cur_artist)
        widget:set_visible(true)

        tooltip.text = "Artist: " .. cur_artist
            .. "\nSong: " .. cur_title
            .. "\nAlbum: " .. cur_album
    end
end

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::music", function(args)
    update(w, args)
end)

--- Adds mouse controls to the widget:
--  - left click - minimize/unminimize player
--  - right click - play/pause
--  - scroll up - volume up
--  - scroll down - volume down
music:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then -- left click
        if not running then
            running = true
            helpers.run_apps({ settings.musicplayer })
        end
        show_player()
    elseif (button == 3) then
        awful.spawn("playerctl -p " .. settings.musicplayer .. " play-pause", false) -- right click
    elseif (button == 4) then
        awful.spawn.with_shell(
            "playerctl -p " .. settings.musicplayer .. " volume 0.03+") -- scroll up
    elseif (button == 5) then
        awful.spawn.with_shell(
            "playerctl -p " .. settings.musicplayer .. " volume 0.03-") -- scroll down
    end
end)

-- Hide Player when changing tags
tag.connect_signal("property::selected", function(t)
    hide_player()
end)

-- ===================================================================
-- Widget
-- ===================================================================

return music