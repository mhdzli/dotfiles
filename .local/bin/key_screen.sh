#!/bin/sh
dmode="$(cat /sys/class/drm/card0-DP-2/status)"
# This script is called as root and without X knowledge
export DISPLAY=:1
if [ "${dmode}" = disconnected ]; then
  setxkbmap de
  xrandr --output DP2 --off --output eDP1 --auto;
elif [ "${dmode}" = connected ]; then
#  setxkbmap us
#  setxkbmap -device 13 de
  xrandr --output DP2 --auto --output eDP1 --auto --output DP2 --right-of eDP1;
fi


feh --bg-fill ~/.config/wallpaper.png;


