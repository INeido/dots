--      █████╗ ██████╗ ██████╗ ███████╗
--      ██╔══██╗██╔══██╗██╔══██╗██╔════╝
--      ███████║██████╔╝██████╔╝███████╗
--      ██╔══██║██╔═══╝ ██╔═══╝ ╚════██║
--      ██║  ██║██║     ██║     ███████║
--      ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝                             


local apps = {
    terminal = "alacritty",
    launcher = "rofi",
    --switcher = require("widgets.alt-tab"),
    --xrandr = "lxrandr",
    screenshot = "shutter",
    --volume = "pavucontrol",
    --appearance = "lxappearance",
    browser = "firefox",
    fileexplorer = "dolphin",
    musicplayer = "spotify-launcher",
    --settings = "code /home/parndt/awesome/"
    editor = os.getenv("EDITOR") or "nano",
}

user = {
    terminal = "alacritty",
    floating_terminal = "alacritty"
}

return apps
