# My theme for GRUB2

To have the Terminus font I install the `terminus-font-ttf` package and after editing the `/etc/default/grub` file and set the font and background path I simply run these 2 commands:

```
sudo grub-mkfont -s 28 -o /usr/share/grub/themes/my-theme/terminus_bold_28.pf2 /usr/share/fonts/TTF/TerminusTTF-Bold.ttf
sudo grub-mkconfig -o /boot/grub/grub.cfg 
```

The first command create a proper `pf2` font and the second one regenerate the grub config

