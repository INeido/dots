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
-- Variables
-- ===================================================================

local cur_artist = ""
local cur_title = ""
local cur_album = ""
local cur_art = ""
local vol_timer = nil
local prog_timer = nil

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
            -- Margins
            {
                {
                    -- Titel Text
                    {
                        id = "titlew",
                        text = "Nothing playing",
                        font = beautiful.dashboardfont_normal,
                        align = "center",
                        widget = wibox.widget.textbox,
                    },
                    -- Artist Text
                    {
                        id = "artistw",
                        text = "wub wub",
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
                    -- Previous Button
                    {
                        id = "prevw",
                        markup = "<span foreground='" .. beautiful.fg_deselected .. "'></span>",
                        text = "",
                        font = beautiful.iconfont_big,
                        align = "center",
                        valign = "center",
                        forced_height = dpi(30),
                        widget = wibox.widget.textbox,
                        buttons = awful.util.table.join(
                            awful.button({}, 1, function()
                                awful.util.spawn("playerctl previous")
                            end)
                        )
                    },
                    -- Play/Pause Button
                    {
                        id = "ppw",
                        font = beautiful.iconfont_big,
                        align = "center",
                        valign = "center",
                        forced_height = dpi(30),
                        widget = wibox.widget.textbox,
                        buttons = awful.util.table.join(
                            awful.button({}, 1, function()
                                awful.util.spawn("playerctl play-pause")
                            end)
                        )
                    },
                    -- Next Button
                    {
                        id = "nextw",
                        markup = "<span foreground='" .. beautiful.fg_deselected .. "'></span>",
                        text = "",
                        font = beautiful.iconfont_big,
                        align = "center",
                        valign = "center",
                        forced_height = dpi(30),
                        widget = wibox.widget.textbox,
                        buttons = awful.util.table.join(
                            awful.button({}, 1, function()
                                awful.util.spawn("playerctl next")
                            end)
                        ),
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
        {
            -- Progressbar
            {
                id               = "progressw",
                max_value        = 1,
                forced_height    = dpi(10),
                color            = beautiful.accent,
                background_color = beautiful.bg_normal,
                visible          = false,
                widget           = wibox.widget.progressbar,
            },
            fill_horizontal = true,
            valign          = "bottom",
            widget          = wibox.container.place,
        },
        {
            {
                id = "iconw",
                markup = "<span foreground='" .. beautiful.accent .. "'></span>",
                font = beautiful.iconfont_huge,
                align = "center",
                visible = false,
                widget = wibox.widget.textbox,
            },
            fill_horizontal = true,
            align           = "center",
            valign          = "center",
            widget          = wibox.container.place,
        },
        layout = wibox.layout.stack,
    },
    forced_height = dpi(320),
    forced_width = dpi(320),
    bg = beautiful.bg_normal,
    widget = wibox.container.background,

    set_art = function(self, link)
        awful.spawn.easy_async("curl -o " .. beautiful.spotify_temp .. "/spotify.png " .. link,
            function(_, _, _, _)
                awful.spawn.easy_async(
                    "convert " ..
                    beautiful.spotify_temp ..
                    "/spotify.png -alpha set -channel A -evaluate set 20% " ..
                    beautiful.spotify_temp .. "/spotify_faded.png",
                    function(_, _, _, _)
                        self:get_children_by_id("artw")[1]:set_image(gears.surface.load_uncached(
                            "" .. beautiful.spotify_temp .. "/spotify_faded.png"))
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

local update = function(args, _, _, _)
    -- Update status
    w:set_status(args.status == 'Playing' and true or false)

    -- Update running
    if args.status ~= "Playing" and args.status ~= "Paused" then
        w:get_children_by_id("artw")[1]:set_image(beautiful.icon_spotify)
        w:set_text("Click to open", "Spotify not running")
        return
    end

    -- Update cover art
    if cur_art ~= args.art and args.art ~= nil then
        cur_art = args.art
        w:set_art(cur_art)
    end

    -- Catch podcast
    if args.artist == nil and args.album ~= nil then
        cur_artist = args.album -- Podcasts are whack. The artist is under the 'album' metadata
        cur_title = args.title

        w:set_text(cur_title, cur_artist)
        w:set_visible(true)
    end

    -- Update text
    if args.artist ~= nil and args.title ~= nil and args.album ~= nil then
        cur_artist = args.artist
        cur_title = args.title
        cur_album = args.album

        w:set_text(cur_title, cur_artist)
        w:set_visible(true)
    end

    -- Update progress
    local pos = 0
    if args.position ~= nil and args.length ~= nil and args.volume ~= nil then
        if vol_timer ~= nil then
            pos = args.volume
        else
            local success, result = pcall(function()
                pos = args.position / (args.length / 1000 / 1000)
            end)
        end
    end
    w:get_children_by_id("progressw")[1]:set_value(tonumber(pos))
end

local change_volume = function(value)
    awful.spawn.with_shell("playerctl -p spotify volume " .. value)

    w:get_children_by_id("iconw")[1]:set_visible(true)

    if vol_timer ~= nil then
        vol_timer:again()
    else
        vol_timer = gears.timer {
            timeout = 1,
            autostart = true,
            callback = function()
                w:get_children_by_id("iconw")[1]:set_visible(false)
                vol_timer:stop()
                vol_timer = nil
            end
        }
    end
end

local hide_progressbar = function()
    prog_timer = gears.timer {
        timeout = 1,
        autostart = true,
        callback = function()
            w:get_children_by_id("progressw")[1]:set_visible(false)
            prog_timer:stop()
            prog_timer = nil
        end
    }
end

-- ===================================================================
-- Signals
-- ===================================================================

w:connect_signal("mouse::enter", function()
    -- TO-DO: Currently disabled because of bugs
    --if prog_timer ~= nil then
    --    prog_timer:again()
    --end
    w:get_children_by_id("progressw")[1]:set_visible(true)
end)
w:connect_signal("mouse::leave", function()
    --hide_progressbar()
    w:get_children_by_id("progressw")[1]:set_visible(false)
end)

w:get_children_by_id("prevw")[1]:connect_signal("mouse::enter", function()
    w:get_children_by_id("prevw")[1]:set_markup("<span foreground='" ..
    beautiful.fg_normal .. "'>" .. w:get_children_by_id("prevw")[1]:get_text() .. "</span>")
end)
w:get_children_by_id("prevw")[1]:connect_signal("mouse::leave", function()
    w:get_children_by_id("prevw")[1]:set_markup("<span foreground='" ..
    beautiful.fg_deselected .. "'>" .. w:get_children_by_id("prevw")[1]:get_text() .. "</span>")
end)

w:get_children_by_id("ppw")[1]:connect_signal("mouse::enter", function()
    w:get_children_by_id("ppw")[1]:set_font(beautiful.iconfont_bigger)
end)
w:get_children_by_id("ppw")[1]:connect_signal("mouse::leave", function()
    w:get_children_by_id("ppw")[1]:set_font(beautiful.iconfont_big)
end)

w:get_children_by_id("nextw")[1]:connect_signal("mouse::enter", function()
    w:get_children_by_id("nextw")[1]:set_markup("<span foreground='" ..
    beautiful.fg_normal .. "'>" .. w:get_children_by_id("nextw")[1]:get_text() .. "</span>")
end)
w:get_children_by_id("nextw")[1]:connect_signal("mouse::leave", function()
    w:get_children_by_id("nextw")[1]:set_markup("<span foreground='" ..
    beautiful.fg_deselected .. "'>" .. w:get_children_by_id("nextw")[1]:get_text() .. "</span>")
end)

awesome.connect_signal("evil::spotify", function(args)
    update(args)
end)

--- Adds mouse controls to the widget:
--  - left click - minimize/unminimize spotify
--  - right click - play/pause
--  - scroll up - volume up
--  - scroll down - volume down
w:connect_signal("button::press", function(_, _, _, button)
    if (button == 3) then
        awful.spawn("playerctl -p spotify play-pause", false) -- right click
    elseif (button == 4) then
        change_volume("0.01+")                                -- scroll up
    elseif (button == 5) then
        change_volume("0.01-")                                -- scroll down
    end
end)

return w
