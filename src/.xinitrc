#!/bin/sh

# xinitrc runs automatically when you run startx.

# There are some small but important commands that need to be run when we start
# the graphical environment. I keep those commands in ~/.xprofile because that
# file is run automatically if someone uses a display manager (login screen)
# and so they are needed there. To prevent doubling up commands, I source them
# here with the line below.

[ -f ~/.xprofile ] && . ~/.xprofile

# Fix Gnome Apps Slow  Start due to failing services
# Add this when you include flatpak in your system
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Here we start dwm.
# The loop is just to enable dwm's "restart" feature (mod+F2).
#exec dwm
ssh-agent dwm
