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

VS Code in fullscreen
![](https://github.com/INeido/dots/blob/main/samples/sample2.png?raw=true)

<br>

Dashboard
![](https://github.com/INeido/dots/blob/main/samples/sample3.png?raw=true)

<br>

Powermenu
![](https://github.com/INeido/dots/blob/main/samples/sample4.png?raw=true)

<br>

Lockscreen
![](https://github.com/INeido/dots/blob/main/samples/sample5.png?raw=true)

<br>

</details>

<br>


# Info

| | Name | Package | Links |
|-| ---- | ------- | ----- |
| **Shell** | zsh | `zsh` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/zsh/)</sup> | [Website](https://www.zsh.org/)
| **Window Manager** | AwesomeWM | `awesome-git` <sup>[AUR](https://aur.archlinux.org/packages/awesome-git)</sup> | [GitHub](https://github.com/awesomeWM/awesome), [Docs](https://awesomewm.org/apidoc/)
| **Compositor** | Picom | `picom` <sup>[Arch](https://archlinux.org/packages/community/x86_64/picom/)</sup> | [GitHub](https://github.com/yshui/picom/wiki)
| **Editor** | VS Code | `code` <sup>[Arch](https://archlinux.org/packages/community/x86_64/code/)</sup> | [GitHub](https://github.com/microsoft/vscode), [Docs](https://github.com/microsoft/vscode/wiki)
| **Terminal** | Alacritty | `alacritty` <sup>[Arch](https://archlinux.org/packages/community/x86_64/alacritty/)</sup> | [GitHub](https://github.com/alacritty/alacritty), [Docs](https://github.com/alacritty/alacritty/wiki)
| **Monitor** | HTOP | `htop` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/htop/)</sup> | [GitHub](https://github.com/htop-dev/htop), [Docs](https://man.archlinux.org/man/htop.1.en)
| **Browser** | Qutebrowser | `qutebrowser` <sup>[Arch](https://archlinux.org/packages/community/x86_64/qutebrowser/)</sup> | [Docs](https://www.qutebrowser.org/doc/help/index.html)
| **File Manager** | Nemo | `nemo` <sup>[Arch](https://archlinux.org/packages/community/x86_64/nemo/)</sup> | [GitHub](https://github.com/linuxmint/nemo), [Docs](https://wiki.archlinux.org/title/Nemo)
| **Application Launcher** | Rofi | `rofi` <sup>[Arch](https://archlinux.org/packages/community/x86_64/rofi/)</sup> | [GitHub](https://github.com/davatorium/rofi), [Docs](https://github.com/davatorium/rofi/wiki)
| **System Font** | Inter | `inter-font`<sup>[Arch](https://archlinux.org/packages/community/any/inter-font/)</sup> | [GitHub](https://github.com/rsms/inter)
| **VS Code Font** | Fira Code | `ttf-fira-code`<sup>[Arch](https://archlinux.org/packages/community/any/ttf-fira-code/)</sup> | [GitHub](https://github.com/tonsky/FiraCode), [Docs](https://github.com/tonsky/FiraCode/wiki)
| **Icon Theme** | Papirus | `papirus-icon-theme`<sup>[Arch](https://archlinux.org/packages/community/any/inter-font/)</sup> | [GitHub](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)


# Setup

NOTE: The following instructions require Arch and AwesomeWM to be installed!

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
    # You may need to run...
    python -m ensurepip
    # before running...
    python -m pip install -r python_requirements.txt
    ```

4. Finally, the dots can be installed using dotdrop.
    ```bash
    dotdrop install --profile=PC0
    ```


<details close>
    <summary><samp><b>More Setup</b></samp></summary>

<br>

Optional requirements. For these you have to enable the 'multilib' repository in pacman.

    ```bash
    # Uncomment multilib
    sudo nano /etc/pacman.conf
    
    pacman -S --needed - < opt_requirements.txt
    ```

A few more things to watch out for.

1. Installing oh-my-zsh and plugins:
    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.config/oh-my-zsh/custom}/plugins/zsh-autosuggestions

    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.config/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ```

2. Network Manager service has to be enabled and started:
    ```bash
    sudo systemctl enable NetworkManager.service

    sudo systemctl start NetworkManager.service
    ```

3. Tthe Network Manager Applet and the pacman update script has to be started as sudo. We have to therefore disable the requirement for a password. Add the following line to your /etc/sudoers.d by doing:
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
    <Username> ALL=NOPASSWD: /usr/bin/nm-applet, /home/<Username>/.config/awesome/scripts/pacman.sh
    ```

</details>

<details close>
    <summary><samp><b>Tips & Tricks</b></samp></summary>

<br>

1. Installing yay.
    ```bash
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

2. Enable auto-login using systemd.
    Create a new service by creatign the following file:
    ```bash
    sudo nano /etc/systemd/system/getty@tty1.service.d/autologin.conf
    ```

    Paste this text, with your Username, into the file
    ```
    [Service]
    ExecStart=
    ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin <Username> %I $TERM
    ```

    Retart the daemon
    ```bash
    sudo systemctl daemon-reload
    ```

3. Set your screen DPI.
    First, go to [dpi.lv](https://dpi.lv/) and figure out your DPI.
    You can then enter this DPI in the following file to set it system-wide:
    ```bash
    nano .Xresources
    ```

    Enter ```Xft.dpi: <your DPI>``` and save.

</details>


# Features

### Music widget

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

You can interact with the minimal music widget in the top panel using:
- Left click: Toggle Player Visibility
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

Using the [settings.lua](https://github.com/INeido/dots/blob/main/dotfiles/config/awesome/config/settings.lua) file you can change a few settings. After a change AwesomeWM has to be reloaded.

The options should be pretty self explanatory.

You can edit the autostart apps in the ../scripts/autostart.sh file.


# Keys

### Global
| Task | Bind |
| ---- | ---- |
| Reload AwesomeWM | mod + control + r |
| Quit AwesomeWM | mod + shift + q |
| Open Dashboard | mod + d |
| Open Powermenu | mod + p |
| Lock computer | mod + l |
| Fullscreen screenshot | mod + t |
| Selection screenshot | mod + r |
| Color picker | mod + c |

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
| Move to next screen | mod + v |
| Move to tag | mod + shift + \<tag number> |

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
- [x] Improve ~~spotify~~ music widget
- [x] Add lock screen
- [x] Multimonitor support
- [x] Improve notifications
- [ ] Improve client switcher (alt+tab)
- [ ] Improve window decorations
- [ ] Improve tasklist
- [ ] Add screen saver
- [ ] Add settings menu
- [ ] Laptop support
- [ ] Add animations [(rubato)](https://open-vsx.org/vscode/item?itemName=s-nlf-fh.glassit)
- [ ] Add more bugs