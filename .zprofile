

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	if [[ $HOST == "latitude" || $HOST == "erazer" ]]; then
		# Wayland specific env variable
		export MOZ_ENABLE_WAYLAND=1
		export MOZ_DBUS_REMOTE=1 # Testing out
		export XDG_CURRENT_DESKTOP=sway
		export XDG_SESSION_TYPE=wayland
		export _JAVA_AWT_WM_NONREPARENTING=1
		# Needed for obs on wayland
		export QT_QPA_PLATFORM=wayland
		export BEMENU_BACKEND=wayland

		# Android studio doesn't support wayland 
		alias android-studio="QT_QPA_PLATFORM=xcb android-studio"
		
		# Fix for monitor sizes using DisplayPort
		export WINIT_HIDPI_FACTOR=1.0

		# Startup Sway
		eval $(ssh-agent)
		# Run using dbus (used by tray)
		exec sway &> /tmp/sway.log
	fi
fi
