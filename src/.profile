#!/usr/bin/env sh
# Profile file. Runs on login.

# Adds `~/.local/bin/` and all subdirectories to $PATH
echo "$0" | grep "zsh$" >/dev/null && export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
echo "$0" | grep "bash$" >/dev/null && export PATH="${PATH}:$(find ~/.local/bin -type d | tr '\n' ':' | sed 's/:$//')"

export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$XDG_DATA_HOME/go"
export PATH="$PATH:$GOPATH/bin"
export EDITOR="nvim"
export MENU="fuzzel --log-level=none --log-no-syslog -w 80 -I -d"
export LAUNCHER="fuzzel"
export TERMINAL="foot"
export BROWSER="firefox"
export READER="zathura"
export FILE="vifm"
#export BIB="$HOME/Documents/LaTeX/uni.bib"
#export REFER="$HOME/Documents/referbib"
export SUDO_ASKPASS="$HOME/.local/bin/menupass"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export ZDOTDIR="$HOME/.config/zsh"
export LESSHISTFILE="$HOME/.cache/less/history"
### Set vim as manpager ###
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist noma number relativenumber' -\""
# export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma number relativenumber' -\""


# Wayland env wariables
set_wayland_env(){
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_WAYLAND_USE_VAAPI=1
	export MOZ_DBUS_REMOTE=1
	export NO_AT_BRIDGE=1
	# export GDK_BACKEND=wayland #Wayland will be selected by default. Do not set GDK_BACKEND, it will break apps (e.g. Chromium and Electron).
	export GTK_IM_MOUDLE=xim
	export ELM_ENGINE=wayland
	export CLUTTER_BACKEND=wayland
	export SDL_VIDEODRIVER=wayland
	export QT_QPA_PLATFORM=wayland
	export QT_WAYLAND_FORCE_DPI=physical
	export QT_WAYLAND_DISABLE_WINDOWDECORATION=1 # hide window decoratins in older versions of QT
	export QT_QPA_PLATFORMTHEME=qt5ct # Qt applications running natively might have missing functionality. For example, KeepassXC will be unable to minimize to tray. This can be solved by installing qt5ct and setting this env VAR
	export ECORE_EVAS_ENGINE=wayland
	export _JAVA_AWT_WM_NONREPARENTING=1
	export XMODIFIERS=@im=ibus
	export LIBSEAT_BACKEND=logind
	export XDG_SESSION_TYPE=wayland
	export XDG_SESSION_DESKTOP=sway
	export XDG_CURRENT_DESKTOP=sway
	# export QT_IM_MODULE=ibus
}

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# fzf options
export FZF_DEFAULT_OPTS='--height 70% --layout=reverse --border'

# gtk3 and qt5 themes
# export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE="kvantum-dark"
export GTK_THEME="Adwaita:dark"

# Start graphical server if it's not already running.
[ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && set_wayland_env &&  XKB_DEFAULT_LAYOUT=us exec sway
[ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 2 ] && set_wayland_env &&  XKB_DEFAULT_LAYOUT=us exec Hyprland
[ "${XDG_VTNR}" -eq 3 ] && ! pgrep -x Xorg >/dev/null && exec startx
