#!/bin/sh
set -e

# Variables
REQUIREMENTS="zsh awesome-git rofi lolcat neofetch playerctl brightnessctl acpi ttf-font-awesome imagemagick networkmanager maim xclip papirus-icon-theme pacman-contrib lxsession"
APPLICATIONS="code htop nemo qutebrowser alacritty spotify-launcher"
OPTIONAL="discord vlc steam signal-desktop remmina bitwarden lutris virt-manager python freerdp network-manager-applet networkmanager-openvpn"

# Greeter
echo "Welcome to the install script!"

echo "This script will..."
echo "  1. Run a full system update."
echo "  2. Make sure yay is installed."
echo "  3. Install dependencies."
echo "  4. Install the dotfiles."

read -n 1 -s -r -p "Press any key when ready..."

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
			yay -S --needed $package
		else
			echo "$package is already installed"
		fi
	done
}

# Installs selected applications
install_applications() {
	local REQ="$@"
	for package in $REQ; do
		if ! yay -Qs $package >/dev/null; then
			echo "$package is not installed. Installing $package..."
			yay -S --needed $package
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
		echo "$name configs detected, backing up..."
		if ! [ -d ~/$folder.old ]; then
			mkdir ~/$folder.old
		fi
		mv ~/$folder/* ~/$folder.old/
		cp -r ./dots/dotfiles/$folder/* ~/$folder
	else
		echo "Installing $name configs..."
		mkdir ~/$folder
		cp -r ./dots/dotfiles/$folder/* ~/$folder
	fi
}

# Backup current settings and copy new ones
update_file() {
	local file="$1"
	local name="$2"
	if [ -f ~/$file ]; then
		echo "$name config detected, backing up..."
		mv ~/$file ~/$file.old
		cp ./dots/dotfiles/$file ~/$file
	else
		echo "Installing $name configs..."
		cp ./dots/dotfiles/$file ~/$file
	fi
}

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

# Install oh-my-zsh
CHSH="no"
RUNZSH="no"
KEEP_ZSHRC="yes"
ZSH="$HOME/.config/oh-my-zsh"
if [ -d $ZSH ]; then
	echo "oh-my-zsh is already installed"
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
git clone https://github.com/INeido/dots
echo ""

echo "Copying dotfiles..."
update_file ".zshrc" "zshrc"
update_folder ".config/alacritty" "Alacritty"
update_folder ".config/neofetch" "Neofetch"
update_folder ".config/qutebrowser" "Qutebrowser"
update_folder ".config/rofi" "Rofi"
update_folder ".config/awesome" "Awesome"

echo ""
echo "==================================================================="
echo "Installing optional packages..."
echo "==================================================================="
echo ""

echo "Packages ($(echo $APPLICATIONS | wc -w)) $APPLICATIONS"
echo ""

read -r -p ":: Do you want to install my recommended packages? [Y/n]: " opt
echo ""

case $opt in
[yY][eE][sS]|[yY])
	install_if_needed $APPLICATIONS;;
[nN][oO]|[nN])
	continue;;
[*])
	install_if_needed $APPLICATIONS;;
esac

echo ""
echo ""
echo "Packages ($(echo $OPTIONAL | wc -w)) $OPTIONAL"
echo ""

read -r -p ":: Do you want to install optional packages? [Y/n]: " opt
echo ""

case $opt in
[yY][eE][sS]|[yY])
	install_if_needed $OPTIONAL;;
[nN][oO]|[nN])
	continue;;
[*])
	install_if_needed $OPTIONAL;;
esac

# 5.
echo ""
echo "==================================================================="
echo "Finishing up..."
echo "==================================================================="
echo ""

echo "Cleaning temp files..."
rm -rf ./dots >/dev/null

echo ""
echo ""
echo "Installation complete!"
