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
		# sudo?
		# samples take a long time
		# "dont disturb" mode where everything goes into bulletin
		#
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

# Installs packages with a choice for the user
install_optional() {
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

# Backup current settings and copy new ones
update_folder() {
	local folder="$1"
	local name="$2"
	if [ -d $HOME/$folder ]; then
		if [ $backup = "yes" ]; then
			echo "$name configs detected, backing up..."
			if [ -d $HOME/$folder.bak ]; then
				rm -rf $HOME/$folder.bak
				mkdir $HOME/$folder.bak
			else
				mkdir $HOME/$folder.bak
			fi
			mv $HOME/$folder $HOME/$folder.bak
		else
			echo "$name configs detected, deleting..."
			rm -rf $HOME/$folder
		fi
	fi
	echo "Installing $name configs..."
	mkdir $HOME/$folder
	cp -r ./dots/dotfiles/$folder/* $HOME/$folder
}

# Backup current settings and copy new ones
update_file() {
	local file="$1"
	local name="$2"
	if [ -f $HOME/$file ]; then
		if [ $backup = "yes" ]; then
			echo "$name config detected, backing up..."
			mv $HOME/$file $HOME/$file.bak
		else
			rm -rf $HOME/$file
		fi
	else
		echo "Installing $name configs..."
	fi
	cp ./dots/dotfiles/$file $HOME/$file
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

	echo "Autologin enabled for user: $USER"
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
if [ -d "$HOME/.config/oh-my-zsh" ]; then
	if [ $backup = "yes" ]; then
		echo "oh-my-zsh configs detected, backing up..."
		if [ -d $HOME/.config/oh-my-zsh.bak ]; then
			rm -rf $HOME/.config/oh-my-zsh.bak
			mkdir $HOME/.config/oh-my-zsh.bak
		else
			mkdir $HOME/.config/oh-my-zsh.bak
		fi
		mv $HOME/.config/oh-my-zsh $HOME/.config/oh-my-zsh.bak
	else
		echo "oh-my-zsh configs detected, deleting..."
		rm -rf $HOME/.config/oh-my-zsh
	fi
fi
echo "Installing oh-my-zsh..."
ZSH="$HOME/.config/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

if [ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
	echo "zsh-autosuggestions is already installed"
else
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
	echo "zsh-syntax-highlighting is already installed"
else
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
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
# Only clone dotfiles, we don't need the samples
git clone --depth=1 --filter=blob:none --sparse https://github.com/INeido/dots
cd dots
git sparse-checkout init --cone
git sparse-checkout set dotfiles
cd ..
echo ""

echo "Copying dotfiles..."
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
update_folder ".themes/Neido: Code" "GTK Theme"
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
echo "Packages ($(echo $APPLICATIONS | wc -w)) $APPLICATIONS"
echo ""

read -r -p ":: Do you want to install my recommended packages? [Y/n]: " rec
echo ""

case $rec in
[yY][eE][sS] | [yY])
	install_optional $APPLICATIONS
	;;
[nN][oO] | [nN])
	continue
	;;
[*])
	install_optional $APPLICATIONS
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
echo "==================================================================="
echo "Finishing up..."
echo "==================================================================="
echo ""

adjust_xinit_file

echo ""
echo "Cleaning temp files..."
rm -rf ./dots >/dev/null

echo ""
echo "Installation complete!"
echo ""
echo "Make sure to complete the finishing touches as explained on the github repo:"
echo "https://github.com/INeido/dots/wiki/Setup"

if pgrep awesome >/dev/null; then
	echo "Restart AwesomeWM using the keybind: CRTL + SUPER (Windows) + R"
else
	echo "Start AwesomeWM by typing 'startx'"
fi
