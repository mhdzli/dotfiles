# mz-dotfiles
My configs and dotfiles for [SWAYWM](https://swaywm.org/). Sway is almost a drop-in replacement for i3, but you may have to make a few changes to get everything working correctly. There is an [`i3 Migration Guide`](https://github.com/swaywm/sway/wiki/i3-Migration-Guide) on `Sway` wiki. Most of the tools and configurations on `Sway` work properly on any window manager based on `wlroots`.

I prefer to keep most of my system configs in my `$HOME`. But some of them are needed to be done in `root` directory. So I add those into [root branch](../root/). These configs are needed to add a few functions for my laptop and in most cases you don't need them.(eg: A [udev rule](../root/etc/udev/rules.d/99_battery_threshold.rules) to set charging [threshold for battery](https://fosstodon.org/@mzeinali/103684222479793025).)

I use us, ir-mz (a custom Persian layout with minor modifications to Persian standard) layouts for may keyboard and there are some configs related to that. you may not need those too.

## My scripts
Most of them are in `.local/bin`. You can use them in both `Wayland` and `X`. I used to switch between `Sway` in `tty1` and [`DWM`](https://github.com/mhdzli/dwm) in `tty2` without any problem. But nowadays I switch totally to wayland and mostly use `Sway` and `Hyprland`.

## Managing dotfiles with `Git` bare repo

I moved all of my configs that should be in home directory to [home branch](../home) and all root related configs to [root branch](../root). I'm using a bare git repository to manage my configs. You can read more about this method in these links:

- [Hacker News](https://news.ycombinator.com/item?id=11070797)
- [Atlassian's Blog](https://www.atlassian.com/git/tutorials/dotfiles)
- [Coffee Addict](https://coffeeaddict.dev/how-to-manage-dotfiles-with-git-bare-repo)

In all of these articles it's recommended to use different branches to manage the configs which are differ depending on the system hardware, OS, ...
I don't have many files among my dotfiles which depend on the system.

There is a few lines in my `Sway` config which I put them in system specific files:
- [zenbbook](../home/.config/sway/zenbook.conf)
- [thinkpad](../home/.config/sway/thinkpad.conf)

Also a few lines in my `Hyprland` config:
- [zenbbook](../home/.config/hypr/zenbook.conf)
- [thinkpad](../home/.config/sway/thinkpad.conf)

I just make symlinks to the related files and source them in the base config file. e.g: In my `Thinkpad` for `Sway` I make the symlink with `ln -s $HOME/.config/sway/thinkpad.conf $HOME/.config/sway/config.d/10-sys.conf` and it is sourced with `include config.d/*` line in [`Sway` config](../home/.config/sway/config) and for `Hyprland` the symlink is made by `ln -s $HOME/.config/hypr/thinkpad.conf $HOME/.config/hypr/config.d/09-sys.conf` and sourced with `source = ~/.config/hypr/config.d/09-sys.conf` in [`Hyprland` config](../home/.config/hypr/hyprland.conf).

And then there are a few modules in my yambar config which need hardware names or specifications. I use [this script](../home/.config/yambar/mkconfig/mkconfig) to generate the config file everytime I change the `Yambar` configs or update my configs using `git pull`.

## Key bindings

Most of my key bindings in `Sway`, `DWM` and `Hyprland` are similar and you can find a help at the end of my [Sway config](../home/.config/sway/config.d/06-keybindings.conf).

## Other Menu Apps

I've been using `fuzzel` since `sway` became my daily driver. [`lbnon fork of rofi`](https://github.com/lbonn/rofi) works in both `Wayland` and `X11` and if you want to use other menu (app launcher) apps I recommend you use dmenu on `X11` and on sway you can have `bemenu`, `wofi` or even there are forks of `dmenu` which run on native wayland.

<details>
<summary>Here are some example configs for sway:</summary>
<p>

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
  $menu		rofi -modi drun,run -show

  ### Another alternative use wofi ###
  #$menu 	wofi --show drun,run
}
```

</p>
</details>
