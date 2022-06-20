# Fix for monitor sizes using DisplayPort
export WINIT_HIDPI_FACTOR=1.0

#
# Custom Executables
#

# Adding go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin

# Adding cargo
if [[ -f $HOME/.cargo/env ]]; then
	. "$HOME/.cargo/env"
fi

# Add Deno Install
export DENO_INSTALL="/home/lyr/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Adding local bin to path
export PATH="$PATH:$HOME/.local/bin"

# Add gem executables
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"

# Adding custom executables
export PATH="$PATH:$HOME/bin"

# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	if [[ $HOST == "home" ]]; then
		# Startup X
		#  exec ssh-agent startx

		# Startup Sway
		eval $(ssh-agent)

		export MOZ_ENABLE_WAYLAND=1
		export MOZ_DBUS_REMOTE=1 # Testing out
		export XDG_CURRENT_DESKTOP=sway
		export XDG_SESSION_TYPE=wayland
		export _JAVA_AWT_WM_NONREPARENTING=1
		export QT_QPA_PLATFORM=wayland

		exec sway &> /tmp/sway.log
	fi
fi
