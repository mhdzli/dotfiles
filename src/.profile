#!/usr/bin/env sh
# Profile file. Runs on login.

# Adds `~/.local/bin/` and all subdirectories to $PATH
export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:GOPATH/bin"
export EDITOR="nvim"
export TERMINAL="foot"
export BROWSER="qutebrowser"
export READER="zathura"
export FILE="vifm"
#export BIB="$HOME/Documents/LaTeX/uni.bib"
#export REFER="$HOME/Documents/referbib"
#export SUDO_ASKPASS="$HOME/.local/bin/tools/dmenupass"
export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export ZDOTDIR="$HOME/.config/zsh"
### Set vim as manpager ###
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist noma number relativenumber' -\""
# export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma number relativenumber' -\""


# Wayland env wariables
set_wayland_env(){
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_WAYLAND_USE_VAAPI=1
	export MOZ_DBUS_REMOTE=1
	export NO_AT_BRIDGE=1
	export GDK_BACKEND=wayland
	export GTK_IM_MOUDLE=xim
	export ELM_ENGINE=wayland_egl
	export CLUTTER_BACKEND=wayland
	export SDL_VIDEODRIVER=wayland
	export QT_QPA_PLATFORM=wayland-egl
	export ECORE_EVAS_ENGINE=wayland-egl
	export _JAVA_AWT_WM_NONREPARENTING=1
	export XMODIFIERS=@im=ibus
    export LIBSEAT_BACKEND=logind
	export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway
	# export QT_IM_MODULE=ibus
}

# less/man colors
export LESS=-R
# export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"; a="${a%_}"
# export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"; a="${a%_}"
# export LESS_TERMCAP_me="$(printf '%b' '[0m')"; a="${a%_}"
# export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; a="${a%_}"
# export LESS_TERMCAP_se="$(printf '%b' '[0m')"; a="${a%_}"
# export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"; a="${a%_}"
# export LESS_TERMCAP_ue="$(printf '%b' '[0m')"; a="${a%_}"
# export LESS_TERMCAP_mb=$(printf '[1;31m')
# export LESS_TERMCAP_md=$(printf '[1;36m')
# export LESS_TERMCAP_me=$(printf '[0m')
# export LESS_TERMCAP_so=$(printf '[01;44;33m')
# export LESS_TERMCAP_se=$(printf '[0m')
# export LESS_TERMCAP_us=$(printf '[1;32m')
# export LESS_TERMCAP_ue=$(printf '[0m')

# fzf options
export FZF_DEFAULT_OPTS='--height 70% --layout=reverse --border'

# gtk3 and qt5 themes
# export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE="kvantum-dark"
export GTK_THEME="Adwaita:dark"

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty2" ] && ! pgrep -x Xorg >/dev/null && exec startx
[ "$(tty)" = "/dev/tty3" ] && ! pgrep -x Xorg >/dev/null && exec startx
[ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && set_wayland_env &&  XKB_DEFAULT_LAYOUT=us exec sway

source /home/mzeinali/.config/broot/launcher/bash/br
