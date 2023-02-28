--      ███████╗██████╗  ██████╗ ████████╗██╗███████╗██╗   ██╗
--      ██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║██╔════╝╚██╗ ██╔╝
--      ███████╗██████╔╝██║   ██║   ██║   ██║█████╗   ╚████╔╝
--      ╚════██║██╔═══╝ ██║   ██║   ██║   ██║██╔══╝    ╚██╔╝
--      ███████║██║     ╚██████╔╝   ██║   ██║██║        ██║
--      ╚══════╝╚═╝      ╚═════╝    ╚═╝   ╚═╝╚═╝        ╚═╝


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

local cur_art = ""
local running = false

-- ===================================================================
-- Spotify
-- ===================================================================

local w = wibox.widget {
    -- Background Color
    {
        -- Background Image
        {
            id = "artw",
            resize = true,
            widget = wibox.widget.imagebox,
        },
        -- Vertical Stack of Widgets
        {
            -- Add Margins
            {
                {
                    -- Titel
                    {
                        id = "titlew",
                        font = beautiful.dashboardfont_normal,
                        align = "center",
                        widget = wibox.widget.textbox,
                    },
                    -- Artist
                    {
                        id = "artistw",
                        font = beautiful.dashboardfont_thin,
                        align = "center",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.align.vertical,
                },
                -- Spacer
                nil,
                -- Controls
                {
                    -- Previous
                    {
                        id = "prevw",
                        markup = "<b></b>",
                        font = beautiful.iconfont_big,
                        align = "center",
                        valign = "center",
                        widget = wibox.widget.textbox,
                        buttons = awful.util.table.join(
                            awful.button({}, 1, function()
                                awful.util.spawn("playerctl previous")
                            end)
                        )
                    },
                    -- Play/Pause
                    {
                        id = "ppw",
                        font = beautiful.iconfont_big,
                        align = "center",
                        valign = "center",
                        widget = wibox.widget.textbox,
                        buttons = awful.util.table.join(
                            awful.button({}, 1, function()
                                awful.util.spawn("playerctl play-pause")
                            end)
                        )
                    },
                    -- Next
                    {
                        id = "nextw",
                        markup = "<b></b>",
                        font = beautiful.iconfont_big,
                        align = "center",
                        valign = "center",
                        widget = wibox.widget.textbox,
                        buttons = awful.util.table.join(
                            awful.button({}, 1, function()
                                awful.util.spawn("playerctl next")
                            end)
                        )
                    },
                    layout = wibox.layout.flex.horizontal,
                },
                layout = wibox.layout.align.vertical,
            },
            top = dpi(50),
            bottom = dpi(50),
            left = dpi(25),
            right = dpi(25),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.stack,
    },
    forced_height = dpi(320),
    forced_width = dpi(320),
    bg = beautiful.bg_normal,
    widget = wibox.container.background,

    set_art = function(self, link)
        awful.spawn.easy_async("curl -o /tmp/spotify.png " .. link,
            function(_, _, _, _)
                awful.spawn.easy_async(
                    "convert /tmp/spotify.png -alpha set -channel A -evaluate set 20% /tmp/spotify_faded.png",
                    function(_, _, _, _)
                        self:get_children_by_id("artw")[1]:set_image(gears.surface.load_uncached(
                            "/tmp/spotify_faded.png"))
                        self:get_children_by_id("artw")[1]:emit_signal("widget::redraw_needed")
                    end)
            end)
    end,

    set_status = function(self, is_playing)
        self:get_children_by_id("ppw")[1]:set_markup(is_playing and
        "<span foreground='" .. beautiful.accent .. "'></span>" or
        "<span foreground='" .. beautiful.accent .. "'></span>")
        self:get_children_by_id("ppw")[1]:emit_signal("widget::redraw_needed")
    end,

    set_text = function(self, title, artist)
        local title_to_display = title
        if self:get_children_by_id("titlew")[1]:get_text() ~= title_to_display then
            self:get_children_by_id("titlew")[1]:set_markup(title_to_display)
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

local update_art = function(widget, stdout, _, _, _)
    if cur_art ~= stdout then
        cur_art = stdout
        widget:set_art(cur_art)
    end
end

local update_status = function(widget, stdout, _, _, _)
    local status = string.gsub(stdout, "\n", "")
    widget:set_status(status == "Playing" and true or false)
end

local update_widget_text = function(widget, stdout, _, _, _)
    if string.find(stdout, "Error: Spotify is not running.") ~= nil then
        running = false
        widget:get_children_by_id("artw")[1]:set_image(beautiful.icon_spotify)
        widget:set_text("Click to open", "Spotify not running")
        return
    end

    running = true

    local escaped = string.gsub(stdout, "&", "&amp;")
    local album, _, artist, title =
        string.match(escaped, "Album%s*(.*)\nAlbumArtist%s*(.*)\nArtist%s*(.*)\nTitle%s*(.*)\n")

    if album ~= nil and title ~= nil and artist ~= nil then
        widget:set_text(title, artist)
        widget:set_visible(true)
    end
end

-- ===================================================================
-- Signal
-- ===================================================================

awesome.connect_signal("evil::spotify_art", function(args)
    update_art(w, args.art)
    collectgarbage("collect")
end)

awesome.connect_signal("evil::spotify_status", function(args)
    update_status(w, args.status)
    collectgarbage("collect")
end)

awesome.connect_signal("evil::spotify_song", function(args)
    update_widget_text(w, args.song)
    collectgarbage("collect")
end)

--- Adds mouse controls to the widget:
--  - left click - minimize/unminimize spotify
--  - right click - play/pause
--  - scroll up - volume up
--  - scroll down - volume down
w:connect_signal("button::press", function(_, _, _, button)
    if (button == 3) then
        awful.spawn("sp play", false) -- right click
    elseif (button == 4) then
        awful.spawn.with_shell(
            "pactl set-sink-input-volume $(pactl list sink-inputs | grep \"Spotify\" -B 18 | grep \"Sink Input\" | awk '{print $3}' | tr -d '#') +2%") -- scroll up
    elseif (button == 5) then
        awful.spawn.with_shell(
            "pactl set-sink-input-volume $(pactl list sink-inputs | grep \"Spotify\" -B 18 | grep \"Sink Input\" | awk '{print $3}' | tr -d '#') -2%") -- scroll down
    end
end)

return w
