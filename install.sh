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
	zsh \
	rust \
	telegram-desktop \
	nodejs yarn \
	openssh \
	neovim tmux bmon htop curl wget p7zip jq tree \
	stow \
	fcitx \
	fcitx-table-extra \
	fcitx-configtool \
	lxappearance-gtk3 \
	pulsemixer brightnessctl \
	mpv \
	wmname \
	fzf

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
	intellij-idea-ultimate-edition-jre webstorm-jre \
       	visual-studio-code-bin \
       	slack-desktop \
	enpass-bin \
	bluez-utils \
	fcitx-qt5 \
	libinput-gestures xdotool wmctrl \
	insomnia-bin \
	1password \
	dunst-git \
	sway \
	swaylock \
	swayidle \
	kanshi \
	waybar \
	otf-font-awesome \
	ttf-font-awesome \
  autotiling-rs-git \
  yofi-git \
  autojump-rs

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh p10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo -e "${GREEN}Package Installation Completed!!${NC}"

stow zsh
stow p10k
stow dunst
stow mpv
stow sway
stow waybar
stow kanshi
stow alacritty
stow nvim
stow fcitx
stow yofi

echo -e "${GREEN}Configuration files linked${NC}"
sudo systemctl enable auto-cpufreq

# Docker user

sudo usermod -aG docker $USER

# Git config
git config --global user.name "Ricky Lam"
git config --global user.email "rm1138@gmail.com"
git config --global pull.rebase true


# prevent docker expose port to public
echo "{ "iptables": false }" | sudo tee -a /etc/docker/daemon.json > /dev/null

# ufw config
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo allow ssh
sudo enable

