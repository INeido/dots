<div align=center>

<a href="https://awesomewm.org/"><img alt="AwesomeWM Logo" height="160" src="https://upload.wikimedia.org/wikipedia/commons/0/07/Awesome_logo.svg"></a>

<div align="center">
    <a href="https://awesomewm.org/"><img src ="https://img.shields.io/badge/Awesomewm-6c5d87.svg?&style=for-the-badge&logo=Lua&logoColor=white"/></a>
    <a href="https://archlinux.org/"><img src ="https://img.shields.io/badge/ArchLinux-4ba383.svg?&style=for-the-badge&logo=Arch Linux&logoColor=white"/></a>
</div>

</div>


# Dotfiles
Requires Arch Linux and AwesomeWM.

![](https://github.com/INeido/dots/blob/main/samples/sample1.png?raw=true)

![](https://github.com/INeido/dots/blob/main/samples/sample2.png?raw=true)

![](https://github.com/INeido/dots/blob/main/samples/sample3.png?raw=true)

![](https://github.com/INeido/dots/blob/main/samples/sample0.png?raw=true)
    

# Components
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


# Installation
First, clone the package.
```bash
git clone https://github.com/INeido/dots
cd ./dots
```

Then, install the arch requirements.
```bash
pacman -S --needed - < arch_requirements.txt
```

Dont forget the python requirements.
```bash
pip install -e python_requirements.txt
```

Finally, the dots can be installed using dotdrop.
```bash
dotdrop install
```

Optional requirements.
```bash
pacman -S --needed - < opt_requirements.txt
```

# Some more Installation
A few more things to watch out for.

1. To have transparency in VS-Code you either need to force it with picom or install the [Glassit](https://open-vsx.org/vscode/item?itemName=s-nlf-fh.glassit) extension. I also recommend enabeling the custom titlebar in the settings.
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