#!/bin/bash

RED='\033[0;31m'
GREEN='\033[38;5;46m'
NC='\033[0m'

echo -e "${GREEN}Installing package from Offical Repo${NC}"
sudo pacman -S --needed --noconfirm \
	base-devel \
	docker \
        firefox-developer-edition chromium \
       	alacritty \ 
	fish \
	picom \
	rust \
	telegram-desktop \
	nodejs yarn \
	openssh \
	neovim tmux bmon htop curl wget p7zip jq tree \
	stow \
	feh \
	dunst \
	ulauncher

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
	auto-cpufreq 

echo -e "${GREEN}Package Installation Completed!!${NC}"

stow fish
stow bspwm
stow sxhkd
stow polybar
stow dunst
stow ulauncher
stow picom
stow mpv

echo -e "${GREEN}Configuration files linked${NC}"
sudo systemctl enable auto-cpufreq
