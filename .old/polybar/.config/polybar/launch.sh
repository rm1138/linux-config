#!/usr/bin/env bash

killall -q polybar


export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

if [ "$DEFAULT_NETWORK_INTERFACE" = "wlp3s0" ]
then
	export DEFAULT_NETWORK_INTERFACE=false
fi

for i in /sys/class/hwmon/hwmon*/temp*_input; do 
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "k10temp: Tdie" ]; then
        export HWMON_PATH="$i"
    fi
done

echo $HWMON_PATH
exit 0

# make sure the primary launch first and own the tray
if type "xrandr"; then
  PRIMARY=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
  OTHERS=$(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1)

  MONITOR=$PRIMARY polybar --reload bottom-bar &
  sleep 1

  for m in $OTHERS; do
    MONITOR=$m polybar --reload bottom-bar &
  done
else
  polybar --reload bottom-bar &
fi
