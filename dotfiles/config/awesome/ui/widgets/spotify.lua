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

local function ellipsize(text, length)
    -- utf8 only available in Lua 5.3+
    if utf8 == nil then
        return text:sub(0, length)
    end
    return (utf8.len(text) > length and length > 0)
        and text:sub(0, utf8.offset(text, length - 2) - 1) .. '...'
        or text
end

local function open_spotify()
    local clients = client.get()
    for _, c in pairs(clients) do
        if c.name == "Spotify" then
            c.minimized = not c.minimized
            if not c.minimized then

            end

            c:raise()
            return
        end
    end
end

local play_icon = "/usr/share/icons/Papirus/64x64/apps/spotify.svg"
local pause_icon = "/usr/share/icons/Papirus/24x24/panel/spotify-indicator.svg"
local font = beautiful.widgetfont
local dim_when_paused = true
local dim_opacity = 0.75
local max_length = -1
local show_tooltip = false
local timeout = 1
local sp_bin = 'sp'

local GET_SPOTIFY_STATUS_CMD = sp_bin .. ' status'
local GET_CURRENT_SONG_CMD = sp_bin .. ' current'
local PLAY_PAUSE_CMD = sp_bin .. ' play'
local NEXT_SONG_CMD = sp_bin .. ' next'
local PREVIOUS_SONG_CMD = sp_bin .. ' prev'

local cur_artist = ''
local cur_title = ''
local cur_album = ''

local spotify = wibox.widget {

    {
        id = 'artistw',
        font = font,
        widget = wibox.widget.textbox,
    },
    {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.margin,
            margins = dpi(4),
            {
                id = "icon",
                widget = wibox.widget.imagebox,
            }
        },
        {
            widget = wibox.widget.textbox,
            font = font,
            text = ' ',
            forced_height = dpi(1)
        }
    },
    {
        layout = wibox.container.scroll.horizontal,
        max_size = dpi(100),
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        speed = 40,
        {
            id = 'titlew',
            font = font,
            widget = wibox.widget.textbox
        }
    },
    layout = wibox.layout.align.horizontal,
    set_status = function(self, is_playing)
        self:get_children_by_id('icon')[1]:set_image(is_playing and play_icon or pause_icon)
        if dim_when_paused then
            self:get_children_by_id('icon')[1]:set_opacity(is_playing and 1 or dim_opacity)

            self:get_children_by_id('titlew')[1]:set_opacity(is_playing and 1 or dim_opacity)
            self:get_children_by_id('titlew')[1]:emit_signal('widget::redraw_needed')

            self:get_children_by_id('artistw')[1]:set_opacity(is_playing and 1 or dim_opacity)
            self:get_children_by_id('artistw')[1]:emit_signal('widget::redraw_needed')
        end
    end,
    set_text = function(self, artist, song)
        local artist_to_display = ellipsize(artist, max_length)
        if self:get_children_by_id('artistw')[1]:get_markup() ~= artist_to_display then
            self:get_children_by_id('artistw')[1]:set_markup(artist_to_display)
        end
        local title_to_display = ellipsize(song, max_length)
        if self:get_children_by_id('titlew')[1]:get_markup() ~= title_to_display then
            self:get_children_by_id('titlew')[1]:set_markup(title_to_display)
        end
    end
}

local update_widget_icon = function(widget, stdout, _, _, _)
    stdout = string.gsub(stdout, "\n", "")
    widget:set_status(stdout == 'Playing' and true or false)
end

local update_widget_text = function(widget, stdout, _, _, _)
    if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
        widget:set_text('', '')
        widget:set_visible(false)
        return
    end

    local escaped = string.gsub(stdout, "&", '&amp;')
    local album, _, artist, title =
    string.match(escaped, 'Album%s*(.*)\nAlbumArtist%s*(.*)\nArtist%s*(.*)\nTitle%s*(.*)\n')

    if album ~= nil and title ~= nil and artist ~= nil then
        cur_artist = artist
        cur_title = title
        cur_album = album

        widget:set_text(artist, title)
        widget:set_visible(true)
    end
end

awful.widget.watch(GET_SPOTIFY_STATUS_CMD, timeout, update_widget_icon, spotify)
awful.widget.watch(GET_CURRENT_SONG_CMD, timeout, update_widget_text, spotify)

--- Adds mouse controls to the widget:
--  - left click - minimize/unminimize spotify
--  - right click - play/pause
--  - scroll up - volume up
--  - scroll down - volume down
spotify:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then -- left click
        open_spotify()
    elseif (button == 3) then
        awful.spawn(PLAY_PAUSE_CMD, false) -- right click
    elseif (button == 4) then
        awful.spawn.with_shell("pactl set-sink-input-volume $(pactl list sink-inputs | grep \"Spotify\" -B 18 | grep \"Sink Input\" | awk '{print $3}' | tr -d '#') +2%") -- scroll up
    elseif (button == 5) then
        awful.spawn.with_shell("pactl set-sink-input-volume $(pactl list sink-inputs | grep \"Spotify\" -B 18 | grep \"Sink Input\" | awk '{print $3}' | tr -d '#') -2%") -- scroll down
    end
    awful.spawn.easy_async(GET_SPOTIFY_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
        update_widget_icon(spotify, stdout, stderr, exitreason, exitcode)
    end)
end)


if show_tooltip then
    local spotify_tooltip = awful.tooltip {
        mode = 'outside',
        preferred_positions = { 'bottom' },
    }

    spotify_tooltip:add_to_object(spotify)

    spotify:connect_signal('mouse::enter', function()
        spotify_tooltip.markup = '<b>Album</b>: ' .. cur_album
            .. '\n<b>Artist</b>: ' .. cur_artist
            .. '\n<b>Song</b>: ' .. cur_title
    end)
end

return wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.panel_item_normal,
    shape = gears.shape.rect,
    {
        widget = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        top = dpi(5),
        bottom = dpi(5),
        {
            spotify,
            layout = wibox.layout.fixed.horizontal
        },
    }
}
