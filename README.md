# mz-dotfiles
My configs and dotfiles for [DWM](https://github.com/mhdzli/dwm) and [SWAYWM](https://swaywm.org/). Sway is almost a drop-in replacement for i3, but you may have to make a few changes to get everything working correctly. There is an [`i3 Migration Guide`](https://github.com/swaywm/sway/wiki/i3-Migration-Guide) on `Sway` wiki.  

I prefer to keep most of my system configs in my `$HOME`. But some of them are needed to be done in `root` directory. So I add those into [root/etc](../../tree/master/src/root/etc). These configs are needed to add a few functions for my laptop and in most cases you don't need them.(eg: A [udev rule](../master/src/root/etc/udev/rules.d/99_battery_threshold.rules) to set charging [threshold for battery](https://fosstodon.org/@mzeinali/103684222479793025).)

I use us,ir layouts for may keyboard and there are some configs related to that. you may not need those too.

## My scripts
Most of them are in `.local/bin`. You can use them in both `Wayland` and `X`. I switch between `Sway` in `tty1` and `DWM` in `tty2` without any problem. 

## Key bindings

Most of my key bindings in `Sway` And `DWM` are similar and you can find a help at the end of my [Sway config](../master/src/.config/sway/config).

## Other Menu apps

Right now I'm using [`lbnon fork of rofi`](https://github.com/lbonn/rofi) which works in both `Wayland` and `X11` but if you want to use  other mene apps I recommend you use dmenu on `X11` and on sway you can have `bemenu`, `wofi` or even there are forks of `dmenu` which run on native wayland.

Here are some example configs for sway:

```
set {
 	# Your preferred application launcher.
  ### dmenu ###
	#$menu	dmenu_path | dmenu | xargs swaymsg exec --
	#$menu	dmenu_path | dmenu -fn "Terminus (TTF):pixelsize=28" | xargs swaymsg exec
	#$menu	j4-dmenu-desktop --dmenu='bemenu -i --nb "#3f3f3f" --nf "#dcdccc" --fn "pango:DejaVu Sans Mono 12"' --term='termite'
	
  ### bemenu ###
  #$menu	bemenu-run -i -p "Run:"  --fn "monospace 14" --hb "#89cff0" --hf "#000000" --tf "#000000" --tb "#2dc7bc" -l 10 
 
  ### rofi ###
  $menu rofi -modi drun,run -show
  
	### Another alternative use wofi ###
	#$menu "wofi --show drun,run"
}
```


