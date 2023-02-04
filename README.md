<div align=center>

<a href="https://awesomewm.org/"><img alt="AwesomeWM Logo" height="160" src="https://upload.wikimedia.org/wikipedia/commons/0/07/Awesome_logo.svg"></a>

<div align="center">
    <a href="https://awesomewm.org/"><img src ="https://img.shields.io/badge/Awesomewm-6c5d87.svg?&style=for-the-badge&logo=Lua&logoColor=white"/></a>
    <a href="https://archlinux.org/"><img src ="https://img.shields.io/badge/ArchLinux-4ba383.svg?&style=for-the-badge&logo=Arch Linux&logoColor=white"/></a>
</div>

</div>


# Dotfiles
Requires Arch Linux and AwesomeWM.


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

Components where the package is `-` have to be installed manually.

Finally, the dots can be installed using dotdrop.
```bash
dotdrop install
```

Optional requirements.
```bash
pacman -S --needed - < opt_requirements.txt
```

# Components
| | Name | Package | Links |
|-| ---- | ------- | ----- |
| **Shell** | zsh | `zsh` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/zsh/)</sup> | [Website](https://www.zsh.org/)
| **Window Manager** | AwesomeWM | `awesome` <sup>[Arch](https://archlinux.org/packages/community/x86_64/awesome/)</sup> | [GitHub](https://github.com/awesomeWM/awesome), [Docs](https://awesomewm.org/apidoc/)
| **Editor** | VS Code | `code` <sup>[Arch](https://archlinux.org/packages/community/x86_64/code/)</sup> | [GitHub](https://github.com/microsoft/vscode), [Docs](https://github.com/microsoft/vscode/wiki)
| **Terminal** | Alacritty | `alacritty` <sup>[Arch](https://archlinux.org/packages/community/x86_64/alacritty/)</sup> | [GitHub](https://github.com/alacritty/alacritty), [Docs](https://github.com/alacritty/alacritty/wiki)
| **Monitor** | HTOP | `htop` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/htop/)</sup> | [GitHub](https://github.com/htop-dev/htop), [Docs](https://man.archlinux.org/man/htop.1.en)
| **Browser** | Firefox | `firefox` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/firefox/)</sup> | [Docs](https://support.mozilla.org/en-US/products/firefox/get-started)
| **Mail** | Thunderbird | `thunderbird` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/thunderbird/)</sup> | [Docs](https://support.mozilla.org/en-US/products/thunderbird/learn-basics-get-started)
| **File Manager** | Dolphin | `dolphin` <sup>[Arch](https://wiki.archlinux.org/title/Dolphin)</sup> | [GitHub](https://github.com/KDE/dolphin), [Docs](https://userbase.kde.org/Dolphin)
| **Application Launcher** | Rofi | `rofi` <sup>[Arch](https://archlinux.org/packages/community/x86_64/rofi/)</sup> | [GitHub](https://github.com/davatorium/rofi), [Docs](https://github.com/davatorium/rofi/wiki)
| **System Font** | Inter | `-` | [GitHub](https://github.com/rsms/inter)
| **VS Code Font** | Fira Code | `-` | [GitHub](https://github.com/tonsky/FiraCode), [Docs](https://github.com/tonsky/FiraCode/wiki)
| **Icon Theme** | Papirus | `-` | [GitHub](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
