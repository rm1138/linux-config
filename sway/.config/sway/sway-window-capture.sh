#!/usr/bin/env bash
set -x 

geometry() {
	windowGeometries=$(
    swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.pid and .visible) | .rect | "\(.x),\(.y) \(.width)x\(.height)"';
	)
	geometry=$(slurp -b "#45858820" -c "#45858880" -w 0 -d <<< "$windowGeometries") || exit $?
	echo $geometry
}

geometry=$(geometry) || exit $?
filename=$(date +'%Y-%m-%d-%H:%M:%S.png')

(grim -g "$geometry" - | wl-copy)
mkdir -p ~/screenshot
wl-paste > ~/screenshot/"$filename" && notify-send "captured $filename"
