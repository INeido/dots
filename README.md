<div align=center>

<a href="https://awesomewm.org/"><img alt="AwesomeWM Logo" height="160" src="https://upload.wikimedia.org/wikipedia/commons/0/07/Awesome_logo.svg"></a>

<div>
    <a href="https://awesomewm.org/"><img src ="https://img.shields.io/badge/Awesomewm-6c5d87.svg?&style=for-the-badge&logo=Lua&logoColor=white"/></a>
    <a href="https://archlinux.org/"><img src ="https://img.shields.io/badge/ArchLinux-4ba383.svg?&style=for-the-badge&logo=Arch Linux&logoColor=white"/></a>
</div>

<div>
    <a href="#welcome">Welcome</a>
    ·
    <a href="#info">Info</a>
    ·
    <a href="#setup">Setup</a>
    ·
    <a href="#features">Features</a>
    ·
    <a href="#settings">Settings</a>
    ·
    <a href="#keys">Keys</a>
    ·
    <a href="#todos">Todos</a>
</div>

</div>


# Welcome

Hello there, random internet person.

This is my daily driver setup on both my home computer and laptop.

Please consider, that this rice is tailored for myself. I did try to make it as configurable as possible, as you will see later if you read on, but it is not perfect.

![](https://github.com/INeido/dots/blob/main/samples/sample1.png?raw=true)

<details close>
    <summary><samp><b>More screenshots</b></samp></summary>

<br>

Dashboard
![](https://github.com/INeido/dots/blob/main/samples/sample2.png?raw=true)

<br>

Powermenu
![](https://github.com/INeido/dots/blob/main/samples/sample3.png?raw=true)

<br>

</details>

<br>


# Info

| | Name | Package | Links |
|-| ---- | ------- | ----- |
| **Shell** | zsh | `zsh` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/zsh/)</sup> | [Website](https://www.zsh.org/)
| **Window Manager** | AwesomeWM | `awesome` <sup>[Arch](https://archlinux.org/packages/community/x86_64/awesome/)</sup> | [GitHub](https://github.com/awesomeWM/awesome), [Docs](https://awesomewm.org/apidoc/)
| **Compositor** | Picom | `picom` <sup>[Arch](https://archlinux.org/packages/community/x86_64/picom/)</sup> | [GitHub](https://github.com/yshui/picom/wiki)
| **Editor** | VS Code | `code` <sup>[Arch](https://archlinux.org/packages/community/x86_64/code/)</sup> | [GitHub](https://github.com/microsoft/vscode), [Docs](https://github.com/microsoft/vscode/wiki)
| **Terminal** | Alacritty | `alacritty` <sup>[Arch](https://archlinux.org/packages/community/x86_64/alacritty/)</sup> | [GitHub](https://github.com/alacritty/alacritty), [Docs](https://github.com/alacritty/alacritty/wiki)
| **Monitor** | HTOP | `htop` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/htop/)</sup> | [GitHub](https://github.com/htop-dev/htop), [Docs](https://man.archlinux.org/man/htop.1.en)
| **Browser** | Qutebrowser | `qutebrowser` <sup>[Arch](https://archlinux.org/packages/community/x86_64/qutebrowser/)</sup> | [Docs](https://www.qutebrowser.org/doc/help/index.html)
| **File Manager** | Thunar | `thunar` <sup>[Arch]( https://archlinux.org/packages/extra/x86_64/thunar/)</sup> | [GitHub](https://github.com/xfce-mirror/thunar), [Docs](https://docs.xfce.org/xfce/thunar/start)
| **Application Launcher** | Rofi | `rofi` <sup>[Arch](https://archlinux.org/packages/community/x86_64/rofi/)</sup> | [GitHub](https://github.com/davatorium/rofi), [Docs](https://github.com/davatorium/rofi/wiki)
| **System Font** | Inter | `inter-font`<sup>[Arch](https://archlinux.org/packages/community/any/inter-font/)</sup> | [GitHub](https://github.com/rsms/inter)
| **VS Code Font** | Fira Code | `ttf-fira-code`<sup>[Arch](https://archlinux.org/packages/community/any/ttf-fira-code/)</sup> | [GitHub](https://github.com/tonsky/FiraCode), [Docs](https://github.com/tonsky/FiraCode/wiki)
| **Icon Theme** | Papirus | `papirus-icon-theme`<sup>[Arch](https://archlinux.org/packages/community/any/inter-font/)</sup> | [GitHub](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)


# Setup

NOTE: The following instructions reuire Arch and AwesomeWM to be installed!

1. Clone the package.
    ```bash
    git clone https://github.com/INeido/dots
    cd ./dots
    ```

2. Install the arch requirements.
    ```bash
    pacman -S --needed - < arch_requirements.txt
    ```

3. Don't forget the python requirements.
    ```bash
    pip install -e python_requirements.txt
    ```

4. Finally, the dots can be installed using dotdrop.
    ```bash
    dotdrop install
    ```

    Optional requirements.
    ```bash
    pacman -S --needed - < opt_requirements.txt
    ```

<details close>
    <summary><samp><b>More Setup</b></samp></summary>

<br>

A few more things to watch out for.

1. To have transparency in VS-Code you either need to force it with picom or install the [Glassit](https://open-vsx.org/vscode/item?itemName=s-nlf-fh.glassit) extension. I also recommend enabling the custom titlebar in the settings.
My settings look like this:
    ```json
    "glassit.alpha": 240,
    "window.titleBarStyle": "custom",
    "workbench.statusBar.visible": false,
    ```

2. Network Manager service has to be enabled:
    ```bash
    sudo systemctl start NetworkManager.service
    ```

3. Powermenu, the Network Manager Applet and the pacman update script has to be started as sudo. We have to therefore disable the requirement for a password. Add the following line to your /etc/sudoers.d by doing:
    ```bash
    # Changes to sudoers have to be done using visudo
    # Optional: Change your editor from vi
    export EDITOR="nano" 
    # Open visudo using the variable you just set
    sudo -E visudo
    ```
    Now you can add the following line:
    ```bash
    # Of course, change <Username> to your username
    <Username> ALL=NOPASSWD: /usr/bin/halt, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/nm-applet, /home/<Username>/.config/awesome/scripts/pacman.sh
    ```

    Start the service
    ```bash
    sudo systemctl start NetworkManager.service
    ```
    
4. The wallpapers are a bit finicky. You have to make sure that they have the exact aspect ration of your display. If that is given, you have to run a script every time you change a wallpaper:
    ```bash
    # You are prompted to enter your screen res as <width>x<height>
    ~/.config/awesome/scripts/blur_backgrounds.sh
    ```

</details>


# Features

### Spotify widget

This widget is visible in the dashboard with the cover art and media buttons.

![](https://github.com/INeido/dots/blob/main/samples/feature0.png?raw=true)

And also as a minimal display in the top panel.

![](https://github.com/INeido/dots/blob/main/samples/feature1.png?raw=true)

<details close>
    <summary><samp><b>more info</b></samp></summary>

When hovering over the widget it displays the song progress using a bar at the bottom.

![](https://github.com/INeido/dots/blob/main/samples/feature0_0.png?raw=true)

Using the scrollwheel you can adjust the volume. When doing so the progress bar transform into the volume bar.

![](https://github.com/INeido/dots/blob/main/samples/feature0_1.png?raw=true)

You can interact with the minimal spotify widget in the top panel using:
- Left click: Toggle Spotify Visibility
- Right click: Toggle play/pause
- Scroll up: Increase volume
- Scroll down: Decrease volume

</details>

### Pacman widget

Minimalistic pacman widget showing the number of pending updates.
Click it to run the updates.

![](https://github.com/INeido/dots/blob/main/samples/feature2.png?raw=true)

### Dashboard

A collection of widgets to conwey important information.

![](https://github.com/INeido/dots/blob/main/samples/feature3.png?raw=true)


### Powermenu

A quick menu to turn off, restart or log off the computer.

![](https://github.com/INeido/dots/blob/main/samples/feature4.png?raw=true)

<details close>
    <summary><samp><b>more info</b></samp></summary>

You can use the arrow keys to switch the selection and press enter to execute. Or just use the mouse.

</details>


# Settings

Using the theme.lua file you can change a few settings. After a change AwesomeWM has to be reloaded.

The options should be pretty self explanatory.

```lua
-- Apps
theme.terminal                     = "alacritty"
theme.browser                      = "firefox"
theme.fileexplorer                 = "thunar"
theme.editor                       = os.getenv("EDITOR") or "nano"

-- Modkeys
theme.modkey                       = "Mod4"
theme.altkey                       = "Mod1"

-- Goodbyer text
theme.goodbyer_text                 = "See ya later"

-- Switches
theme.enable_titlebar              = false

-- Network Interface for the widget
theme.network_interface            = "enp42s0"

-- Enter the drives you want to get data from for the widget
theme.drive_names                  = { "/", "/Games" }

-- Spotify art temp folder
theme.spotify_temp                 = "/tmp"
```

You can edit the autostart apps in the ../scipts/autostart.sh file.


# Keys

### Global
| Task | Bind |
| ---- | ---- |
| Reload AwesomeWM | mod + control + r |
| Quit AwesomeWM | mod + shift + q |
| Open Dashboard | mod + d |
| Open Powermenu | mod + p |
| Fullscreen screenshot | mod + t |
| Selection screenshot | mod + r |

### Apps
| Task | Bind |
| ---- | ---- |
| Run File Explorer | mod + e |
| Run Rofi drun | mod + space |
| Run Terminal | mod + return |

### Client
| Task | Bind |
| ---- | ---- |
| Toggle Fullscreen | mod + f |
| Toggle Maximize | mod + m |
| Toggle Floating | mod + control + space |
| Close | mod + q |
| Keep on top | mod + t |
| Keep minimize | mod + n |
| Move | mod + mouse1 |
| Resie | mod + mouse3 |

### Tag & Layout
| Task | Bind |
| ---- | ---- |
| Previous Tag | mod + left_arrow |
| Next Tag | mod + right_arrow |
| Last Tag | mod + escape |
| Last Client | alt + tab |
| Cycle Clients | mod + tab |
| Cycle Layouts | mod + s |
| View Tag | mod + \<tag number> |


# Todos

- [x] Make it useable
- [x] Add autostart support
- [x] Add dashboard
- [x] Add powermenu
- [x] Improve spotify widget
- [ ] Better client switcher (alt+tab)
- [ ] Better window decorations
- [ ] Add lock screen
- [ ] Add screen saver
- [ ] Add settings menu
- [ ] Add more bugs