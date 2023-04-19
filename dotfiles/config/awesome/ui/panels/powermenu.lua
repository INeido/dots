--      ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
--      ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗████╗ ████║██╔════╝████╗  ██║██║   ██║
--      ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
--      ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
--      ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
--      ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝


-- ===================================================================
-- Initialization
-- ===================================================================

local awful        = require("awful")
local gears        = require("gears")
local wibox        = require("wibox")
local helpers      = require("helpers")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi

-- ===================================================================
-- Load Widgets
-- ===================================================================

local goodbyer     = require("ui.widgets.powermenu.goodbyer")
local buttons      = {
    require("ui.widgets.powermenu.logout"),
    require("ui.widgets.powermenu.shutdown"),
    require("ui.widgets.powermenu.reboot"),
}
local confirmation = require("ui.widgets.powermenu.confirmation")

-- ===================================================================
-- Powermenu
-- ===================================================================

local powermenu    = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    screen = screen.primary,
    bgimage = cache.wallpapers.blurred[1],
})

awful.placement.maximize(powermenu)

local powermenu_extenders = helpers.extend_to_screens()

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
    confirmation.yes.visible = true
    confirmation.no.visible = true

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
    confirmation.yes.visible = false
    confirmation.no.visible = false

    -- Show powermenu
    goodbyer:get_children_by_id("textbox")[1].markup = helpers.text_color(settings.goodbyer_text, beautiful.fg_focus)
    for i, button in ipairs(buttons) do
        button.w.visible = true
    end

    selected_action = nil

    buttons[last_focused].w:emit_signal("mouse::enter")
end

function pm_unfocus()
    for i, button in ipairs(buttons) do
        button.w:emit_signal("mouse::leave")
    end
    confirmation.yes:emit_signal("mouse::leave")
    confirmation.no:emit_signal("mouse::leave")
end

function pm_close()
    awful.keygrabber.stop(powermenu.grabber)
    powermenu.visible = false
    for i, panel in ipairs(powermenu_extenders) do
        panel.visible = false
    end
    confirmation_hide()
end

-- This is a mess
function pm_open()
    -- Unfocus all buttons. For some reason they are all focused sometimes
    pm_unfocus()
    -- Set the first button as active by default
    buttons[1].w:emit_signal("mouse::enter")
    -- Close the Dashboard
    db_close()
    -- Open Powermenu
    powermenu.visible = true
    for i, panel in ipairs(powermenu_extenders) do
        panel.visible = true
    end
    -- Start Keygrabber
    powermenu.grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key == "Escape" or key == "q" or key == "F1" then
            pm_close()
        elseif key == "Left" then
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
        elseif key == "Right" then
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
        elseif key == "Return" or key == "space" then
            if confirmation.yes.visible == true then
                if helpers.button_isfocused(confirmation.yes) then
                    confirmation.yes:emit_signal("button::press", _, _, _, 1)
                else
                    confirmation_hide()
                end
            else
                for _, button in ipairs(buttons) do
                    if helpers.button_isfocused(button.w) then
                        button.w:emit_signal("button::press", _, _, _, 1)
                        break
                    end
                end
            end
        end
    end)
end

function pm_toggle()
    if powermenu.visible then
        pm_close()
    else
        pm_open()
    end
end

-- ===================================================================
-- Setup Widgets
-- ===================================================================

confirmation.yes:connect_signal("button::press", function(_, _, _, button)
    selected_action()
end)

confirmation.no:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        confirmation_hide()
    end
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
    local selected_tags = powermenu.screen.selected_tags

    if #selected_tags > 0 then
        powermenu.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[selected_tags[1].index], powermenu.screen)
    else
        powermenu.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[1], powermenu.screen)
    end

    for i, panel in ipairs(powermenu_extenders) do
        selected_tags = panel.screen.selected_tags

        if #selected_tags > 0 then
            panel.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[selected_tags[1].index], panel.screen)
        else
            panel.bgimage = helpers.surf_maximize(cache.wallpapers.blurred[1], panel.screen)
        end
    end
end)

-- ===================================================================
-- Setup
-- ===================================================================

powermenu:setup {
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
            {
                buttons[1].w,
                buttons[2].w,
                buttons[3].w,
                layout = wibox.layout.fixed.horizontal,
            },
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

return powermenu
