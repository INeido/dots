--      ███████╗██████╗  ██████╗ ████████╗██╗███████╗██╗   ██╗
--      ██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║██╔════╝╚██╗ ██╔╝
--      ███████╗██████╔╝██║   ██║   ██║   ██║█████╗   ╚████╔╝
--      ╚════██║██╔═══╝ ██║   ██║   ██║   ██║██╔══╝    ╚██╔╝
--      ███████║██║     ╚██████╔╝   ██║   ██║██║        ██║
--      ╚══════╝╚═╝      ╚═════╝    ╚═╝   ╚═╝╚═╝        ╚═╝


-------------------------------------------------
-- Original
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/spotify-widget
-------------------------------------------------

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Helper
-- ===================================================================

local function open_spotify()
    local clients = client.get()
    for _, c in pairs(clients) do
        if c.name == "Spotify" or c.name == "Spotify Premium" then
            c.minimized = not c.minimized
            c:raise()
            return
        end
    end
end

local function min_spotify()
    local clients = client.get()
    for _, c in pairs(clients) do
        if c.name == "Spotify" or c.name == "Spotify Premium" then
            c.minimized = true
            c:raise()
            return
        end
    end
end

-- ===================================================================
-- Variables
-- ===================================================================

local dim_opacity = 0.75

local cur_artist = nil
local cur_title = nil
local cur_album = nil
local running = false

-- ===================================================================
-- Spotify
-- ===================================================================

local w = wibox.widget {
    -- Margins
    {
        {
            -- Title Text
            {
                id = "titlew",
                text = "Nothing playing",
                font = beautiful.font .. "11",
                widget = wibox.widget.textbox
            },
            speed = 40,
            max_size = dpi(160),
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            layout = wibox.container.scroll.horizontal,
        },
        {
            -- Connector betwee Title and Artist
            id = "connectorw",
            text = " - ",
            font = beautiful.font .. "11",
            widget = wibox.widget.textbox,
        },
        {
            -- Artist Text
            id = "artistw",
            text = "wub wub",
            font = beautiful.font .. "11",
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,
    },
    left = dpi(5),
    right = dpi(5),
    widget = wibox.container.margin,

    set_status = function(self, is_playing)
        self:get_children_by_id("titlew")[1]:emit_signal("widget::redraw_needed")

        self:get_children_by_id("titlew")[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id("titlew")[1]:emit_signal("widget::redraw_needed")

        self:get_children_by_id("artistw")[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id("artistw")[1]:emit_signal("widget::redraw_needed")
    end,

    set_text = function(self, title, artist)
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

-- ===================================================================
-- Actions
-- ===================================================================

local update = function(widget, args, _, _, _)
    -- Update status
    widget:set_status(args.status == "Playing" and true or false)

    -- Update running
    if args.status ~= "Playing" and args.status ~= "Paused" then
        running = false
        widget:set_text("Click to open", "Spotify not running")
        return
    end
    running = true


    -- Catch podcast
    if args.artist == nil and args.album ~= nil and args.title ~= nil then
        cur_artist = args.album -- Podcasts are whack. The artist is under the 'album' metadata
        cur_title = args.title

        widget:set_text(cur_title, cur_artist)
        widget:set_visible(true)
    end

    -- Update text
    if args.artist ~= nil and args.title ~= nil and args.album ~= nil then
        cur_artist = args.artist
        cur_title = args.title
        cur_album = args.album

        widget:set_text(cur_title, cur_artist)
        widget:set_visible(true)
    end
end


-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::spotify", function(args)
    update(w, args)
end)

-- Box the Widget
local spotify = helpers.box_tp_widget(w, true, 2)

--- Adds mouse controls to the widget:
--  - left click - minimize/unminimize spotify
--  - right click - play/pause
--  - scroll up - volume up
--  - scroll down - volume down
spotify:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then -- left click
        if not running then
            running = true
            awful.spawn("spotify-launcher")
        end
        open_spotify()
    elseif (button == 3) then
        awful.spawn("playerctl -p spotify play-pause", false) -- right click
    elseif (button == 4) then
        awful.spawn.with_shell(
            "playerctl -p spotify volume 0.03+") -- scroll up
    elseif (button == 5) then
        awful.spawn.with_shell(
            "playerctl -p spotify volume 0.03-") -- scroll down
    end
end)

-- Hide Spotify when changing tags
tag.connect_signal("property::selected", function(t)
    min_spotify()
end)

-- ===================================================================
-- Tooltip
-- ===================================================================

if false then
    local spotify_tooltip = awful.tooltip {
        mode = "outside",
        preferred_positions = { "bottom" },
    }

    spotify_tooltip:add_to_object(spotify)

    spotify:connect_signal("mouse::enter", function()
        spotify_tooltip.text = "Album: " .. cur_album
            .. "\nArtist: " .. cur_artist
            .. "\nSong: " .. cur_title
    end)
end

-- ===================================================================
-- Widget
-- ===================================================================

return spotify
