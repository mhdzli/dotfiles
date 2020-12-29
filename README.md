# mz-dotfiles
My configs and dotfiles for [DWM](https://github.com/mhdzli/dwm) and [SWAYWM](https://swaywm.org/).

I prefer to keep most of my system configs in my `$HOME`. But some of them are needed to be done in `root` directory. So I add those into [root/etc](../../tree/master/src/root/etc). These configs are needed to add a few functions for my laptop and in most cases you don't need them.(eg: A [udev rule](../master/src/root/etc/udev/rules.d/99_battery_threshold.rules) to set charging [threshold for battery](https://fosstodon.org/@mzeinali/103684222479793025).)

I use us,ir layouts for may keyboard and there are some configs related to that. you may not need those too.

## My scripts
Most of them are in `.local/bin`. You can use them in both `Wayland` and `X`. I switch between `Sway` in `tty1` and `DWM` in `tty2` without any problem. 

## Key bindings

Most of my key bindings in `Sway` And `DWM + sxhkd` are similar and you can find a help at the end of my [Sway config](../master/src/.config/sway/config).

