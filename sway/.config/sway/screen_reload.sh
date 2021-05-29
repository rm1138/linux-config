#!/usr/bin/bash

swaymsg output eDP-1 disable

sleep 3

if grep -q open /proc/acpi/button/lid/LID/state; then
    swaymsg output eDP-1 enable
else
    swaymsg output eDP-1 disable
fi
