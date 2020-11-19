#!/usr/bin/env sh
# Profile file. Runs on login.

# Adds `~/.local/bin/` and all subdirectories to $PATH
export PATH="$PATH:$HOME/.local/bin/"
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export FILE="vifm"
#export BIB="$HOME/Documents/LaTeX/uni.bib"
#export REFER="$HOME/Documents/referbib"
#export SUDO_ASKPASS="$HOME/.local/bin/tools/dmenupass"
export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export ZDOTDIR="$HOME/.config/zsh"

# Wayland env wariables
export MOZ_ENABLE_WAYLAND=1
export MOZ_WAYLAND_USE_VAAPI=1
export QT_QPA_PLATFORM=wayland-egl 

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$(printf '[1;31m')
export LESS_TERMCAP_md=$(printf '[1;36m')
export LESS_TERMCAP_me=$(printf '[0m')
export LESS_TERMCAP_so=$(printf '[01;44;33m')
export LESS_TERMCAP_se=$(printf '[0m')
export LESS_TERMCAP_us=$(printf '[1;32m')
export LESS_TERMCAP_ue=$(printf '[0m')

# gtk3 and qt5 themes

export QT_STYLE_OVERRIDE="kvantum-dark"
# export GTK_THEME="Adwaita:dark"

mpd >/dev/null 2>&1 &

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty2" ] && ! pgrep -x Xorg >/dev/null && exec startx

[ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] &&  XKB_DEFAULT_LAYOUT=us exec sway



source /home/mzeinali/.config/broot/launcher/bash/br
