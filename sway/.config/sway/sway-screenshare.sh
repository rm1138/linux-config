#!/usr/bin/env bash
set -x 
if ! lsmod | grep v4l2loopback > /dev/null; then
	echo "Adding v42loopback module to kernel"
	pkexec modprobe v4l2loopback
fi

geometry(){
	windowGeometries=$(
		# `height - 1` is there because of: https://github.com/ammen99/wf-recorder/pull/56 (I could remove it if it's merged, maybe)
		swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height - 1)"'; \
		swaymsg -t get_outputs -r | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'
	)
	geometry=$(slurp -b "#45858820" -c "#45858880" -w 3 -d <<< "$windowGeometries") || exit $?
	echo $geometry
}

{
if pgrep wf-recorder > /dev/null; then
	pkill vlc > /dev/null
  pkill wf-recorder > /dev/null
	notify-send -t 2000 "Wayland recording has been stopped"
else
	geometry=$(geometry) || exit $?
  echo "run"
	wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video2 --geometry="$geometry" --pixel-format=yuv420p -t &
  vlc v4l2:///dev/video2 &
	notify-send -t 2000 "Wayland recording has been started"
fi
} > ~/.wayland-share-screen.log 2>&1
