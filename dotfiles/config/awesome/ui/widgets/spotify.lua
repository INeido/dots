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
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- ===================================================================
-- Helper
-- ===================================================================

local function open_spotify()
    local clients = client.get()
    for _, c in pairs(clients) do
        if c.name == "Spotify" then
            c.minimized = not c.minimized
            c:raise()
            return
        end
    end
end

-- ===================================================================
-- Variables
-- ===================================================================

local titelfont = beautiful.widgetfont
local artistfont = beautiful.font
local dim_opacity = 0.75

local sp_bin = 'sp'
local PLAY_PAUSE_CMD = sp_bin .. ' play'

local cur_artist = ''
local cur_title = ''
local cur_album = ''
local cur_art = ''
local running = false

-- ===================================================================
-- Widget
-- ===================================================================

local spotify = wibox.widget {
    {
        {
            id = "artw",
            resize = true,
            widget = wibox.widget.imagebox
        },
        right = dpi(10),
        widget = wibox.container.margin,
    },
    {
        {
            layout = wibox.container.scroll.horizontal,
            max_size = dpi(160),
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 40,
            {
                id = 'titlew',
                font = titelfont,
                widget = wibox.widget.textbox
            }
        },
        {
            id = 'artistw',
            font = artistfont,
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.vertical,
    },
    layout = wibox.layout.align.horizontal,

    set_art = function(self, link)
        awful.spawn.easy_async("curl -o /tmp/spotify.png " .. link,
            function(stdout, stderr, reason, exit_code)
                self:get_children_by_id("artw")[1]:set_image(gears.surface.load_uncached("/tmp/spotify.png"))
                self:get_children_by_id("artw")[1]:emit_signal("widget::redraw_needed")
            end)
    end,

    set_status = function(self, is_playing)
        self:get_children_by_id("artw")[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id('titlew')[1]:emit_signal('widget::redraw_needed')

        self:get_children_by_id('titlew')[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id('titlew')[1]:emit_signal('widget::redraw_needed')

        self:get_children_by_id('artistw')[1]:set_opacity(is_playing and 1 or dim_opacity)
        self:get_children_by_id('artistw')[1]:emit_signal('widget::redraw_needed')
    end,

    set_text = function(self, title, artist)
        local title_to_display = title
        if self:get_children_by_id('titlew')[1]:get_text() ~= title_to_display then
            self:get_children_by_id('titlew')[1]:set_text(title_to_display)
        end
        local artist_to_display = artist
        if self:get_children_by_id('artistw')[1]:get_text() ~= artist_to_display then
            self:get_children_by_id('artistw')[1]:set_text(artist_to_display)
        end
    end
}

-- ===================================================================
-- Actions
-- ===================================================================

local update_art = function(widget, stdout, _, _, _)
    if cur_art ~= stdout then
        cur_art = stdout
        widget:set_art(cur_art)
    end
end

local update_status = function(widget, stdout, _, _, _)
    local status = string.gsub(stdout, "\n", "")
    widget:set_status(status == 'Playing' and true or false)
end

local update_widget_text = function(widget, stdout, _, _, _)
    if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
        running = false
        widget:get_children_by_id("artw")[1]:set_image(beautiful.icon_spotify)
        widget:set_text("Click to open", "Spotify not running")
        return
    end

    running = true

    local escaped = string.gsub(stdout, "&", '&amp;')
    local album, _, artist, title =
        string.match(escaped, 'Album%s*(.*)\nAlbumArtist%s*(.*)\nArtist%s*(.*)\nTitle%s*(.*)\n')

    if album ~= nil and title ~= nil and artist ~= nil then
        cur_artist = artist
        cur_title = title
        cur_album = album

        widget:set_text(title, artist)
        widget:set_visible(true)
    end
end

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::spotify_art", function(args)
    update_art(spotify, args.art)
    collectgarbage('collect')
end)

awesome.connect_signal("evil::spotify_status", function(args)
    update_status(spotify, args.status)
    collectgarbage('collect')
end)

awesome.connect_signal("evil::spotify_song", function(args)
    update_widget_text(spotify, args.song)
    collectgarbage('collect')
end)

--- Adds mouse controls to the widget:
--  - left click - minimize/unminimize spotify
--  - right click - play/pause
--  - scroll up - volume up
--  - scroll down - volume down
spotify:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then -- left click
        if not running then
            awful.spawn("spotify-launcher")
        end
        open_spotify()
    elseif (button == 3) then
        awful.spawn(PLAY_PAUSE_CMD, false) -- right click
    elseif (button == 4) then
        awful.spawn.with_shell(
            "pactl set-sink-input-volume $(pactl list sink-inputs | grep \"Spotify\" -B 18 | grep \"Sink Input\" | awk '{print $3}' | tr -d '#') +2%") -- scroll up
    elseif (button == 5) then
        awful.spawn.with_shell(
            "pactl set-sink-input-volume $(pactl list sink-inputs | grep \"Spotify\" -B 18 | grep \"Sink Input\" | awk '{print $3}' | tr -d '#') -2%") -- scroll down
    end
end)

-- ===================================================================
-- Tooltip
-- ===================================================================

if false then
    local spotify_tooltip = awful.tooltip {
        mode = 'outside',
        preferred_positions = { 'bottom' },
    }

    spotify_tooltip:add_to_object(spotify)

    spotify:connect_signal('mouse::enter', function()
        spotify_tooltip.text = 'Album: ' .. cur_album
            .. '\nArtist: ' .. cur_artist
            .. '\nSong: ' .. cur_title
    end)
end

return wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        left = dpi(5),
        right = dpi(10),
        top = dpi(5),
        bottom = dpi(5),
        {
            spotify,
            layout = wibox.layout.fixed.horizontal
        },
    }
}
