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
    <a href="#settings">Settings</a>
    ·
    <a href="#todos">Todos</a>
</div>

</div>


# Welcome

Hello there, random internet person.

This is my daily driver setup on both my home computer and laptop.

Please consider, that this rice is tailored for myself. I did try to make it as configurable as possible, as you will see later if you read on, but it is not perfect.

Make sure to check out the [Wiki](https://github.com/INeido/dots/wiki) for more information!

![](https://github.com/INeido/dots/blob/main/samples/sample1.png?raw=true)

More pictures in the [Gallery](https://github.com/INeido/dots/wiki/Gallery).


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

| Method | Command |
| ------ | --------|
| **curl** | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/INeido/dots/master/install.sh)"` |
| **wget** | `sh -c "$(wget -O- https://raw.githubusercontent.com/INeido/dots/master/install.sh)"` |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/INeido/dots/master/install.sh)"` |

For manual isntallation see [Setup](https://github.com/INeido/dots/wiki/Setup).

# Settings

Using the [settings.lua](https://github.com/INeido/dots/blob/main/dotfiles/config/awesome/config/settings.lua) file you can change a few settings. After a change AwesomeWM has to be reloaded.

# Todos

- [x] Make it useable
- [x] Add autostart support
- [x] Add dashboard
- [x] Add powermenu
- [x] Improve ~~spotify~~ music widget
- [x] Add lock screen
- [x] Multimonitor support
- [x] Improve notifications
- [x] Improve tasklist
- [ ] Laptop support (Brightness & Volume OSD)
- [ ] Improve client switcher (alt+tab)
- [ ] Improve window decorations
- [ ] Add screen saver
- [ ] Add settings menu
- [ ] Add animations [(rubato)](https://open-vsx.org/vscode/item?itemName=s-nlf-fh.glassit)
- [ ] Add more bugs