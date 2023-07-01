#!/bin/sh
set -e

# Variables
REQUIREMENTS="zsh awesome-git extra/rofi lolcat neofetch playerctl brightnessctl upower acpi ttf-font-awesome ttf-fira-code imagemagick networkmanager maim xclip papirus-icon-theme pacman-contrib picom lxsession code htop nemo qutebrowser alacritty spotify-launcher thefuck nano"
OPTIONAL="vlc python network-manager-applet networkmanager-openvpn pulsemixer"

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
INVERT='\033[7m'
HIDDEN='\033[8m'
STRIKETHROUGH='\033[9m'
NC='\033[0m' # No Color

# Greeter
echo ""
echo -e "${BOLD}Welcome to the install script!${NC}"
echo ""
echo -e "${WHITE}This script will...${NC}"
echo -e "  ${WHITE}1. Run a full system update.${NC}"
echo -e "  ${WHITE}2. Make sure yay is installed.${NC}"
echo -e "  ${WHITE}3. Install requirements.${NC}"
echo -e "  ${WHITE}4. Install the dotfiles.${NC}"
echo -e "  ${WHITE}5. Install optional packages.${NC}"
echo -e "  ${WHITE}6. Cleanup.${NC}"
echo ""

read -n 1 -s -r -p "Press any key when ready..."
echo ""

# Makes sure yay is intalled, as it is needed for this script
ensure_yay() {
	if ! command -v yay &>/dev/null; then
		echo -n "${BLUE}yay${NC} is not installed. Installing yay... "
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si --noconfirm
		cd ~
		rm -rf ~/yay
		echo -e "${GREEN}Done!${NC}"
	else
		echo "yay is already installed"
	fi
}

# Installs packages if needed
install_if_needed() {
	local REQ="$@"
	for package in $REQ; do
		if ! yay -Qs $package >/dev/null; then
			echo -e -n "Installing ${BLUE}$package${NC}... "
			yay -S --noconfirm --needed $package >/dev/null 2>&1
			echo -e "${GREEN}Done!${NC}"
		else
			echo -e "${BLUE}$package${NC} is already installed!"
		fi
	done
}

# Installs packages with a choice for the user
install_optional() {
	local REQ="$@"
	for package in $REQ; do
		if ! yay -Qs $package >/dev/null; then
			echo -e -n "Installing ${BLUE}$package${NC}... "
			yay -S --needed $package
		else
			echo -e "${BLUE}$package${NC} is already installed!"
		fi
	done
}

# Backup current settings and copy new ones
update_folder() {
	local folder="$1"
	local name="$2"
	if [ -d "$HOME/$folder" ]; then
		if [ $backup = "yes" ]; then
			echo -e -n "${BLUE}$name${NC} configs detected, backing up... "
			if [ -d "$HOME/$folder.bak" ]; then
				rm -rf "$HOME/$folder.bak"
				mkdir "$HOME/$folder.bak"
			else
				mkdir "$HOME/$folder.bak"
			fi
			mv "$HOME/$folder" "$HOME/$folder.bak"
			echo -e "${GREEN}Done!${NC}"
		else
			echo -e -n "${BLUE}$name${NC} configs detected, deleting... "
			rm -rf "$HOME/$folder"
			echo -e "${GREEN}Done!${NC}"
		fi
	fi
	echo -e -n "Installing ${BLUE}$name${NC} configs... "
	mkdir -p "$HOME/$folder"
	cp -r "./dots/dotfiles/$folder"/* "$HOME/$folder"
	echo -e "${GREEN}Done!${NC}"
}

# Backup current settings and copy new ones
update_file() {
	local file="$1"
	local name="$2"
	if [ -f $HOME/$file ]; then
		if [ $backup = "yes" ]; then
			echo -e -n "${BLUE}$name${NC} config detected, backing up... "
			mv $HOME/$file $HOME/$file.bak
			echo -e "${GREEN}Done!${NC}"
		else
			rm -rf $HOME/$file
		fi
	fi
	echo -e -n "Installing ${BLUE}$name${NC} configs... "
	mkdir -p "$HOME/$(dirname "$file")"
	cp ./dots/dotfiles/$file $HOME/$file
	echo -e "${GREEN}Done!${NC}"
}

# Adjust xinit file to start AwesomeWM
adjust_xinit_file() {
	# Check if xinit file exists
	if [ -f "$HOME/.xinitrc" ]; then
		# Check if AwesomeWM is already set as the window manager
		if grep -q "exec awesome" "$HOME/.xinitrc"; then
			echo "AwesomeWM is already set as the window manager in $HOME/.xinitrc"
		else
			echo "Backing up existing .xinitrc file to $HOME/.xinitrc.bak"
			mv "$HOME/.xinitrc" "$HOME/.xinitrc.bak"

			# Add line to start AwesomeWM
			echo "exec awesome" >>"$HOME/.xinitrc"
			echo "Added line to start AwesomeWM in $HOME/.xinitrc"
		fi
	else
		# Create xinit file and add line to start AwesomeWM
		echo "exec awesome" >"$HOME/.xinitrc"
		echo "Created $HOME/.xinitrc and added line to start AwesomeWM"
	fi
}

# Enable autologin for the current user
enable_autologin() {
	# Create a new directory for the autologin configuration file
	sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

	# Create the autologin configuration file
	sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\\\u' --noclear --autologin $USER %I \$TERM
EOF

	# Reload the systemd daemon
	sudo systemctl daemon-reload

	echo -e "Autologin enabled for user: ${BLUE}$USER${NC}"
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
echo -e "${NC}\n${YELLOW}===================================================================${NC}"
echo -e "${YELLOW}Updating system...${NC}"
echo -e "${YELLOW}===================================================================${NC}\n"
echo ""

sudo pacman --noconfirm -Syyu
echo ""
echo "Installing prerequisites..."
echo ""
sudo pacman -S --needed git base-devel

# 2.
echo ""
echo -e "${NC}\n${YELLOW}===================================================================${NC}"
echo -e "${YELLOW}Checking yay...${NC}"
echo -e "${YELLOW}===================================================================${NC}\n"
echo ""

ensure_yay

# 3.
echo ""
echo -e "${NC}\n${YELLOW}===================================================================${NC}"
echo -e "${YELLOW}Installing requirements...${NC}"
echo -e "${YELLOW}===================================================================${NC}\n"
echo ""

install_if_needed $REQUIREMENTS

# Install oh-my-zsh and plugins
if [ -d "$HOME/.config/oh-my-zsh" ]; then
	if [ $backup = "yes" ]; then
		echo -e -n "${BLUE}oh-my-zsh${NC} configs detected, backing up... "
		if [ -d $HOME/.config/oh-my-zsh.bak ]; then
			rm -rf $HOME/.config/oh-my-zsh.bak
			mkdir $HOME/.config/oh-my-zsh.bak
		else
			mkdir $HOME/.config/oh-my-zsh.bak
		fi
		mv $HOME/.config/oh-my-zsh $HOME/.config/oh-my-zsh.bak
		echo -e "${GREEN}Done!${NC}"
	else
		echo -e -n "${BLUE}oh-my-zsh${NC} configs detected, deleting..."
		rm -rf $HOME/.config/oh-my-zsh
		echo -e "${GREEN}Done!${NC}"
	fi
else
	echo -e -n "Installing ${BLUE}oh-my-zsh${NC}... "
	ZSH="$HOME/.config/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc >/dev/null 2>&1
	echo -e "${GREEN}Done!${NC}"
fi

if [ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
	echo "${BLUE}zsh-autosuggestions${NC} is already installed!"
else
	echo -e -n "Installing ${BLUE}zsh-autosuggestions${NC} plugin... "
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1
	echo -e "${GREEN}Done!${NC}"
fi
if [ -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
	echo "${BLUE}zsh-syntax-highlighting${NC} is already installed!"
else
	echo -e -n "Installing ${BLUE}zsh-syntax-highlighting${NC} plugin... "
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1
	echo -e "${GREEN}Done!${NC}"
fi

# 4.
echo ""
echo -e "${NC}\n${YELLOW}===================================================================${NC}"
echo -e "${YELLOW}Installing dotfiles...${NC}"
echo -e "${YELLOW}===================================================================${NC}\n"
echo ""

echo -n "Clone Git Repository... "
if [ -d ./dots ]; then
	rm -rf ./dots
fi
# Only clone dotfiles, we don't need the samples
git clone --quiet --depth=1 --filter=blob:none --sparse https://github.com/INeido/dots >/dev/null 2>&1
cd dots
git sparse-checkout init --cone >/dev/null 2>&1
git sparse-checkout set dotfiles >/dev/null 2>&1
cd ..
echo -e "${GREEN}Done!${NC}"
echo ""

echo "Copying dotfiles..."
echo ""
update_file ".zshrc" "zshrc"
update_file ".config/qutebrowser/config.py" "Qutebrowser: config.py"
update_file ".config/qutebrowser/autoconfig.yml" "Qutebrowser: autoconfig.yml"
update_file ".config/alacritty/alacritty.yml" "Alacritty"
update_file ".config/neofetch/config.conf" "Neofetch"
update_file ".config/rofi/code.rasi" "Rofi: code.rasi"
update_file ".config/rofi/launcher.rasi" "Rofi: launcher.rasi"
update_file ".config/rofi/launcher.rasi" "Rofi: launcher.rasi"
update_file ".gtkrc-2.0" "GTK 2.0 Config"
update_file ".config/gtk-3.0/settings.ini" "GTK 3.0 Config"
update_folder ".themes/Neido_Code" "GTK Theme"
update_folder ".config/awesome" "Awesome"

# 5.
echo ""
echo -e "${NC}\n${YELLOW}===================================================================${NC}"
echo -e "${YELLOW}Installing optional packages...${NC}"
echo -e "${YELLOW}===================================================================${NC}\n"
echo ""

read -r -p ":: Do you want to install liblua_pam for the lockscreen? [Y/n]: " pam
echo ""

case $pam in
[yY][eE][sS] | [yY])
	install_if_needed "lua-pam-git"
	cp /usr/lib/lua-pam/liblua_pam.so $HOME/.config/awesome/
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	install_if_needed "lua-pam-git"
	cp /usr/lib/lua-pam/liblua_pam.so $HOME/.config/awesome/
	;;
esac

echo ""
echo "Packages ($(echo $OPTIONAL | wc -w)) $OPTIONAL"
echo ""

read -r -p ":: Do you want to install optional packages? [Y/n]: " opt
echo ""

case $opt in
[yY][eE][sS] | [yY])
	install_optional $OPTIONAL
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	install_optional $OPTIONAL
	;;
esac

echo ""

read -r -p ":: Do you want to enable autologin for tty1? [Y/n]: " login
echo ""

case $login in
[yY][eE][sS] | [yY])
	enable_autologin
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	enable_autologin
	;;
esac

# 6.
echo ""
echo -e "${NC}\n${YELLOW}===================================================================${NC}"
echo -e "${YELLOW}Finishing up...${NC}"
echo -e "${YELLOW}===================================================================${NC}\n"
echo ""

adjust_xinit_file

echo ""
echo "Cleaning temp files..."
rm -rf ./dots >/dev/null

echo ""
echo -e "${BOLD}Installation complete!${NC}"
echo ""
echo "Make sure to complete the Finishing Touches as explained on the github repo:"
echo "https://github.com/INeido/dots/wiki/Setup"

if pgrep awesome >/dev/null; then
	echo "Restart AwesomeWM using the keybind: CRTL + SUPER (Windows) + R"
else
	echo "Start AwesomeWM by typing 'startx'"
fi
