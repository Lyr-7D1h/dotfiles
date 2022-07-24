export LANG=en_US.UTF-8

#
# Custom Executables
#

# Adding go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin

### Exports
# Adding custom executables
export PATH="$PATH:$HOME/.npm/bin"
# Adding custom executables
export PATH="$HOME/bin:$PATH"
# Adding local bin to path
export PATH="$HOME/.local/bin:$PATH"
# Cargo executables
export PATH="$HOME/.cargo/bin:$PATH"


# Add Deno Install
export DENO_INSTALL="/home/lyr/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Add gem executables
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"

# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


if [[ $HOST == "home" ]]; then
	# Wayland specific env variable
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_DBUS_REMOTE=1 # Testing out
	export XDG_CURRENT_DESKTOP=sway
	export XDG_SESSION_TYPE=wayland
	export _JAVA_AWT_WM_NONREPARENTING=1
	# Needed for obs on wayland
	export QT_QPA_PLATFORM=wayland
	
	# Fix for monitor sizes using DisplayPort
	export WINIT_HIDPI_FACTOR=1.0

	# Startup Sway
	if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
		eval $(ssh-agent)
		exec sway &> /tmp/sway.log
	fi
fi
