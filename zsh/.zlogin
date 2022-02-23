# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
  export XDG_SESSION_TYPE=wayland
  export XDG_CURRENT_DESKTOP=sway
	exec dbus-run-session sway
fi
