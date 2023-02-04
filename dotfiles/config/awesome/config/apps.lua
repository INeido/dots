--      █████╗ ██████╗ ██████╗ ███████╗
--      ██╔══██╗██╔══██╗██╔══██╗██╔════╝
--      ███████║██████╔╝██████╔╝███████╗
--      ██╔══██║██╔═══╝ ██╔═══╝ ╚════██║
--      ██║  ██║██║     ██║     ███████║
--      ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝                             


local apps = {
    terminal = "alacritty",
    --launcher = "sh /home/parndt/.config/rofi/launch.sh",
    --switcher = require("widgets.alt-tab"),
    --xrandr = "lxrandr",
    screenshot = "shutter",
    --volume = "pavucontrol",
    --appearance = "lxappearance",
    browser = "firefox",
    fileexplorer = "dolphin",
    musicplayer = "spotify-launcher",
    --settings = "code /home/parndt/awesome/"
}

user = {
    terminal = "alacritty",
    floating_terminal = "alacritty"
}

return apps
