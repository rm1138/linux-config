#!/bin/bash

RED='\033[0;31m'
GREEN='\033[38;5;46m'
NC='\033[0m'

echo -e "${GREEN}Installing package from Offical Repo${NC}"
sudo pacman -S --needed --noconfirm \
	base-devel \
	docker docker-compose \
  firefox-developer-edition chromium \
  alacritty \
	zsh zsh-theme-powerlevel10k \
	rust \
	telegram-desktop \
	nodejs \
  yarn \
	openssh \
	neovim tmux bmon htop curl wget p7zip jq tree \
  usbutils \
	stow \
	fcitx \
	fcitx-table-extra \
	fcitx-configtool \
	lxappearance-gtk3 \
	pulsemixer brightnessctl \
	mpv \
	wmname \
	mako \
	fzf \
  tlp

if ! command -v paru &> /dev/null
then
	echo -e "${GREEN}Installing Paru${NC}"
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	cd ..
	rm -rf paru
else
	echo -e "${GREEN}Paru is installed${NC}"
fi

echo -e "${GREEN}Installing package from AUR Repo${NC}"
paru -S --noconfirm --needed \
	#intellij-idea-ultimate-edition-jre \
  #webstorm-jre \
  visual-studio-code-bin \
  slack-desktop \
	enpass-bin \
	auto-cpufreq \
	bluez-utils \
	fcitx-qt5 \
	#libinput-gestures xdotool wmctrl \
	sway \
	swaylock-effects \
	swayidle \
	kanshi \
	waybar \
	otf-font-awesome \
	ttf-font-awesome \
  nerd-fonts-hack \
  autotiling-rs-git \
  yofi-git \
  autojump-rs \
  slurp grim

if [ ! -d "~/.oh-my-zsh" ] then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# zsh-autosuggestions
if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# zsh p10k theme
if [ ! -d "~/.oh-my-zsh/custom/themes/powerlevel10k" ] then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo -e "${GREEN}Package Installation Completed!!${NC}"

stow zsh
stow p10k
stow mpv
stow sway
stow waybar
stow kanshi
stow mako
stow gitconfig
stow yofi
stow nvim
stow alacritty
stow fcitx

# tlp setting
sudo cp ./tlp.conf /etc/tlp.conf
sudo systemctl enable tlp
sudo tlp start

echo -e "${GREEN}Configuration files linked${NC}"
sudo systemctl enable auto-cpufreq

# Docker user
sudo usermod -aG docker $USER

echo 85 | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold

# change default browser
xdg-settings set default-web-browser firefox-developer-edition.desktop

# prevent docker expose port to public
echo "{ "iptables": false }" | sudo tee -a /etc/docker/daemon.json > /dev/null

# ufw config
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo allow ssh
sudo enable

