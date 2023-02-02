# dots
My dotfiles
It requires Arch Linux with KDE.


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

# Components
| | Name | Package | Links |
|-| ---- | ------- | ----- |
| **Shell** | zsh | `zsh` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/zsh/)</sup> | [Website](https://www.zsh.org/)
| **Window Manager** | KDE | `plasma-desktop` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/plasma-desktop/)</sup> | [GitHub](https://github.com/KDE/plasma-desktop), [Docs](https://docs.kde.org/)
| **Editor** | Neovim | `neovim` <sup>[Arch](https://www.archlinux.org/packages/community/x86_64/neovim/)</sup> | [GitHub](https://github.com/neovim/neovim), [Docs](https://github.com/neovim/neovim/wiki)
| **Terminal** | Alacritty | `alacritty` <sup>[Arch](https://archlinux.org/packages/community/x86_64/alacritty/)</sup> | [GitHub](https://github.com/alacritty/alacritty), [Docs](https://github.com/alacritty/alacritty/wiki)
| **Monitor** | HTOP | `htop` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/htop/)</sup> | [GitHub](https://github.com/htop-dev/htop), [Docs](https://man.archlinux.org/man/htop.1.en)
| **Browser** | Firefox | `firefox` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/firefox/)</sup> | [Docs](https://support.mozilla.org/en-US/products/firefox/get-started)
| **Mail** | Thunderbird | `thunderbird` <sup>[Arch](https://archlinux.org/packages/extra/x86_64/thunderbird/)</sup> | [Docs](https://support.mozilla.org/en-US/products/thunderbird/learn-basics-get-started)
| **File Manager** | Dolphin | `dolphin` <sup>[Arch](https://wiki.archlinux.org/title/Dolphin)</sup> | [GitHub](https://github.com/KDE/dolphin), [Docs](https://userbase.kde.org/Dolphin)
| **Application Launcher** | KRunner | `krunner` <sup>[Arch](https://wiki.archlinux.org/title/KRunner)</sup> | [GitHub](https://github.com/KDE/krunner), [Docs](https://userbase.kde.org/Plasma/Krunner)
| **System Font** | Inter | `-` | [GitHub](https://github.com/rsms/inter)
| **VS Code Font** | Fira Code | `-` | [GitHub](https://github.com/tonsky/FiraCode), [Docs](https://github.com/tonsky/FiraCode/wiki)
| **Icon Theme** | Papirus | `-` | [GitHub](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
