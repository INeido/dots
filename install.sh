#!/bin/sh
set -e

# Variables
REQUIREMENTS="zsh awesome-git rofi lolcat neofetch playerctl brightnessctl acpi ttf-font-awesome ttf-fira-code imagemagick networkmanager maim xclip papirus-icon-theme pacman-contrib picom lxsession"
APPLICATIONS="code htop nemo qutebrowser alacritty spotify-launcher"
OPTIONAL="discord vlc steam signal-desktop remmina bitwarden lutris virt-manager python freerdp network-manager-applet networkmanager-openvpn"

# Greeter
echo "Welcome to the install script!"
echo ""
echo "This script will..."
echo "  1. Run a full system update."
echo "  2. Make sure yay is installed."
echo "  3. Install requirements."
echo "  4. Install the dotfiles."
echo "  5. Install optional packages."
echo "  5. Cleanup."
echo ""

read -n 1 -s -r -p "Press any key when ready..."
echo ""

# Makes sure yay is intalled, as it is needed for this script
ensure_yay() {
	if ! command -v yay &>/dev/null; then
		echo "yay is not installed. Installing yay..."
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si
	else
		echo "yay is already installed"
	fi
}

# Installs packages if needed
install_if_needed() {
	local REQ="$@"
	for package in $REQ; do
		if ! yay -Qs $package >/dev/null; then
			echo "Installing $package"
			yay -S --noconfirm --needed $package
		else
			echo "$package is already installed"
		fi
	done
}

# Backup current settings and copy new ones
update_folder() {
	local folder="$1"
	local name="$2"
	if [ -d ~/$folder ]; then
		if [ $backup = "yes" ]; then
			echo "$name configs detected, backing up..."
			if [ -d ~/$folder.old ]; then
				rm -rf ~/$folder.old
				mkdir ~/$folder.old
			else
				mkdir ~/$folder.old
			fi
			mv ~/$folder/* ~/$folder.old/
		else
			echo "$name configs detected, deleting..."
			rm -rf ~/$folder
			mkdir ~/$folder
		fi
	else
		mkdir ~/$folder
	fi
	echo "Installing $name configs..."
	cp -r ./dots/dotfiles/$folder/* ~/$folder
}

# Backup current settings and copy new ones
update_file() {
	local file="$1"
	local name="$2"
	if [ -f ~/$file ]; then
		if [ $backup = "yes" ]; then
			echo "$name config detected, backing up..."
			mv ~/$file ~/$file.old
		else
			rm -rf ~/$file
		fi
	else
		echo "Installing $name configs..."
	fi
	cp ./dots/dotfiles/$file ~/$file
}

# Settings
echo ""
read -r -p ":: Do you want to backup old configs? [Y/n]: " backup

case $backup in
[yY][eE][sS] | [yY])
	backup="yes"
	;;
[nN][oO] | [nN])
	backup="no"
	;;
[*])
	backup="yes"
	;;
esac

# 1.
echo ""
echo "==================================================================="
echo "Updating system..."
echo "==================================================================="
echo ""

sudo pacman --noconfirm -Syyu
echo "Installing prerequisites..."
sudo pacman -S --needed git base-devel

# 2.
echo ""
echo "==================================================================="
echo "Checking yay..."
echo "==================================================================="
echo ""

ensure_yay

# 3.
echo ""
echo "==================================================================="
echo "Installing requirements..."
echo "==================================================================="
echo ""

install_if_needed $REQUIREMENTS

# Install oh-my-zsh and plugins
CHSH="no"
RUNZSH="no"
KEEP_ZSHRC="yes"
ZSH="$HOME/.config/oh-my-zsh"
if [ -d $ZSH ]; then
	echo "oh-my-zsh is already installed"
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
	echo "zsh-autosuggestions is already installed"
else
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.config/oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
	echo "zsh-syntax-highlighting is already installed"
else
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.config/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# 4.
echo ""
echo "==================================================================="
echo "Installing dotfiles..."
echo "==================================================================="
echo ""

echo "Clone Git Repository..."
if [ -d ./dots ]; then
	rm -rf ./dots
fi
git clone --depth=1 https://github.com/INeido/dots
echo ""

echo "Copying dotfiles..."
update_file ".zshrc" "zshrc"
update_folder ".config/alacritty" "Alacritty"
update_folder ".config/neofetch" "Neofetch"
update_folder ".config/qutebrowser" "Qutebrowser"
update_folder ".config/rofi" "Rofi"
update_folder ".config/awesome" "Awesome"

# 5.
echo ""
echo "==================================================================="
echo "Installing optional packages..."
echo "==================================================================="
echo ""

read -r -p ":: Do you want to install liblua_pam for the lockscreen? [Y/n]: " pam
echo ""

case $pam in
[yY][eE][sS] | [yY])
	install_if_needed "lua-pam-git"
	cp /usr/lib/lua-pam/liblua_pam.so ~/.config/awesome/
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	install_if_needed "lua-pam-git"
	cp /usr/lib/lua-pam/liblua_pam.so ~/.config/awesome/
	;;
esac

echo ""
echo "Packages ($(echo $APPLICATIONS | wc -w)) $APPLICATIONS"
echo ""

read -r -p ":: Do you want to install my recommended packages? [Y/n]: " rec
echo ""

case $rec in
[yY][eE][sS] | [yY])
	install_if_needed $APPLICATIONS
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	install_if_needed $APPLICATIONS
	;;
esac

echo ""
echo "Packages ($(echo $OPTIONAL | wc -w)) $OPTIONAL"
echo ""

read -r -p ":: Do you want to install optional packages? [Y/n]: " opt
echo ""

case $opt in
[yY][eE][sS] | [yY])
	install_if_needed $OPTIONAL
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	install_if_needed $OPTIONAL
	;;
esac

# 6.
echo ""
echo "==================================================================="
echo "Finishing up..."
echo "==================================================================="
echo ""

echo "Cleaning temp files..."
rm -rf ./dots >/dev/null

echo ""
echo "Installation complete!"
echo ""

if pgrep awesome >/dev/null; then
	echo "Restart AwesomeWM using the keybind: CRTL + SUPER (Windows) + R"
else
	echo "Starting AwesomeWM..."
	if [[ $(tty) = /dev/tty1 ]]; then
		startx
	else
		echo "Not in tty1. Start AwesomeWM manually using: startx"
	fi
fi
