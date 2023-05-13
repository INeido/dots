--      ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
--      ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗████╗ ████║██╔════╝████╗  ██║██║   ██║
--      ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
--      ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
--      ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
--      ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful          = require("awful")
local wibox          = require("wibox")
local helpers        = require("helpers")
local beautiful      = require("beautiful")

-- ===================================================================
-- Load Widgets
-- ===================================================================

local goodbyer       = require("ui.widgets.powermenu.goodbyer")
local confirmation   = require("ui.widgets.powermenu.confirmation")
local create_button  = require("ui.widgets.powermenu.button")

-- ===================================================================
-- Create Buttons
-- ===================================================================

local buttons        = {}
local buttons_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
}

-- To prevent a nil value from entering
local function add_button(icon, action)
    if icon ~= nil then
        local w = create_button(icon)
        -- Add the widget to the table
        table.insert(buttons, {
            w = w,
            a = action
        })
        -- Add the widget to the container widget
        buttons_widget:add(w)
    end
end

-- Lock
add_button("", function()
    awesome.emit_signal("lockscreen::show")
end)
-- Sleep
add_button("", function()
    awesome.emit_signal("lockscreen::show")
    awful.spawn.with_shell("systemctl suspend")
end)
-- Logout
add_button("", function()
    awesome.quit()
end)
-- Shutdown
add_button("", function()
    awful.spawn.with_shell("poweroff")
end)
-- Reboot
add_button("", function()
    awful.spawn.with_shell("reboot")
end)

-- ===================================================================
-- Powermenu
-- ===================================================================

local powermenu = {}

powermenu.panel = wibox({
    visible = false,
    ontop   = true,
    type    = "splash",
    screen  = screen.primary,
    bgimage = cache.wallpapers[screen.primary.index][1].blurred,
})

awful.placement.maximize(powermenu.panel)

-- ===================================================================
-- Variables
-- ===================================================================

powermenu.grabber = nil
local selected_action = nil
local last_focused = 1

-- ===================================================================
-- Functions
-- ===================================================================

local function confirmation_show(action)
    -- Show confirmation
    confirmation.yes.visible                         = true
    confirmation.no.visible                          = true

    -- Hide powermenu
    goodbyer:get_children_by_id("textbox")[1].markup = helpers.text_color(settings.confirmation_text, beautiful.fg_focus)
    for i, button in ipairs(buttons) do
        button.w.visible = false
    end

    -- Default focus
    confirmation.yes:emit_signal("mouse::enter")
    confirmation.no:emit_signal("mouse::leave")

    selected_action = action
end

local function confirmation_hide()
    -- Hide confirmation
    confirmation.yes.visible                         = false
    confirmation.no.visible                          = false

    -- Show powermenu
    goodbyer:get_children_by_id("textbox")[1].markup = helpers.text_color(settings.goodbyer_text, beautiful.fg_focus)
    for i, button in ipairs(buttons) do
        button.w.visible = true
    end

    selected_action = nil

    buttons[last_focused].w:emit_signal("mouse::enter")
end

local function unfocus()
    for i, button in ipairs(buttons) do
        button.w:emit_signal("mouse::leave")
    end
    confirmation.yes:emit_signal("mouse::leave")
    confirmation.no:emit_signal("mouse::leave")
end

local function close()
    awful.keygrabber.stop(powermenu.grabber)
    powermenu.panel.visible = false
    awesome.emit_signal("extender::close")
    confirmation_hide()
end

local function left()
    if confirmation.yes.visible == true then
        if helpers.button_isfocused(confirmation.yes) then
            confirmation.yes:emit_signal("mouse::leave")
            confirmation.no:emit_signal("mouse::enter")
        elseif helpers.button_isfocused(confirmation.no) then
            confirmation.yes:emit_signal("mouse::enter")
            confirmation.no:emit_signal("mouse::leave")
        else
            confirmation.yes:emit_signal("mouse::enter")
            confirmation.no:emit_signal("mouse::leave")
        end
    else
        local focus = false
        for i, button in ipairs(buttons) do
            if helpers.button_isfocused(button.w) then
                -- Move focus to the previous button
                if i > 1 then
                    button.w:emit_signal("mouse::leave")
                    buttons[i - 1].w:emit_signal("mouse::enter")
                elseif i == 1 then
                    button.w:emit_signal("mouse::leave")
                    buttons[#buttons].w:emit_signal("mouse::enter")
                end
                focus = true
                break
            end
        end
        if not focus then
            buttons[#buttons].w:emit_signal("mouse::enter")
        end
    end
end

local function right()
    if confirmation.yes.visible == true then
        if helpers.button_isfocused(confirmation.yes) then
            confirmation.yes:emit_signal("mouse::leave")
            confirmation.no:emit_signal("mouse::enter")
        elseif helpers.button_isfocused(confirmation.no) then
            confirmation.yes:emit_signal("mouse::enter")
            confirmation.no:emit_signal("mouse::leave")
        else
            confirmation.yes:emit_signal("mouse::enter")
            confirmation.no:emit_signal("mouse::leave")
        end
    else
        local focus = false
        for i, button in ipairs(buttons) do
            if helpers.button_isfocused(button.w) then
                -- Move focus to the next button
                if i < #buttons then
                    button.w:emit_signal("mouse::leave")
                    buttons[i + 1].w:emit_signal("mouse::enter")
                elseif i == #buttons then
                    button.w:emit_signal("mouse::leave")
                    buttons[1].w:emit_signal("mouse::enter")
                end
                focus = true
                break
            end
        end
        if not focus then
            buttons[1].w:emit_signal("mouse::enter")
        end
    end
end

local function select(id)
    if id then
        last_focused = id
        confirmation_show(buttons[id].a)
    elseif confirmation.yes.visible == true then
        if helpers.button_isfocused(confirmation.yes) then
            confirmation.yes:emit_signal("button::press", nil, nil, nil, 1)
        else
            confirmation.no:emit_signal("button::press", nil, nil, nil, 1)
        end
    else
        for _, button in ipairs(buttons) do
            if helpers.button_isfocused(button.w) then
                button.w:emit_signal("button::press", nil, nil, nil, 1)
                break
            end
        end
    end
end

local keybinds = {
    ["left"]   = left,
    ["right"]  = right,
    ["return"] = select,
    ["space"]  = select,
    ["escape"] = close,
    ["q"]      = close,
    ["f1"]     = close,
    ["l"]      = function() select(1) end, -- Lock
    ["s"]      = function() select(2) end, -- Sleep
    ["e"]      = function() select(3) end, -- Exit (Logout)
    ["p"]      = function() select(4) end, -- Poweroff (Shutdown)
    ["r"]      = function() select(5) end, -- Reboot
}

-- This is a mess
local function open()
    -- Unfocus all buttons. For some reason they are all focused sometimes
    unfocus()

    -- Set the first button as active by default
    buttons[1].w:emit_signal("mouse::enter")

    -- Close the Dashboard
    awesome.emit_signal("dashboard::close")

    -- Open Powermenu
    powermenu.panel.visible = true
    awesome.emit_signal("extender::open")

    -- Start Keygrabber
    powermenu.grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()

        if event == "release" then return end

        if keybinds[key] then
            keybinds[key]()
        end
    end)
end

local function toggle()
    if powermenu.panel.visible then
        close()
    else
        open()
    end
end

-- ===================================================================
-- Setup Widgets
-- ===================================================================

confirmation.yes:connect_signal("button::press", function(_, _, _, button)
    selected_action()
end)

confirmation.no:connect_signal("button::press", function(_, _, _, button)
    confirmation_hide()
end)

for i, button in ipairs(buttons) do
    button.w:connect_signal("button::press", function(_, _, _, btn)
        last_focused = i
        confirmation_show(button.a)
    end)
end

-- ===================================================================
-- Signals
-- ===================================================================

-- Update background
tag.connect_signal("property::selected", function(t)
    helpers.update_background(powermenu.panel, t)
end)

-- Open powermenu
awesome.connect_signal("powermenu::open", function()
    open()
end)

-- Close powermenu
awesome.connect_signal("powermenu::close", function()
    close()
end)

-- Toggle powermenu
awesome.connect_signal("powermenu::toggle", function()
    toggle()
end)

-- ===================================================================
-- Setup
-- ===================================================================

powermenu.panel:setup {
    -- Center widgets vertically
    nil,
    {
        -- Center widgets horizontally
        nil,
        {
            -- Column container
            goodbyer,
            {
                confirmation.yes,
                confirmation.no,
                layout = wibox.layout.fixed.horizontal,
            },
            buttons_widget,
            layout = wibox.layout.fixed.vertical,
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}
