#!/bin/sh

usage="usage: $0 -c {up|down|mute} [-i increment] [-m mixer]"
command=
increment=5%
mixer=Master

while getopts i:m:h o
do case "$o" in
    i) increment=$OPTARG;;
    m) mixer=$OPTARG;;
    h) echo "$usage"; exit 0;;
    ?) echo "$usage"; exit 0;;
esac
done

shift $(($OPTIND - 1))
command=$1

if [ "$command" = "" ]; then
    echo "usage: $0 {up|down|mute} [increment]"
    exit 0;
fi

display_volume=0

if [ "$command" = "up" ]; then
    display_volume=$(amixer set $mixer $increment+ unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
fi

if [ "$command" = "down" ]; then
    display_volume=$(amixer set $mixer $increment- unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
fi

icon_name=""

if [ "$command" = "mute" ]; then
    if amixer get Master | grep "\[on\]"; then
        icon_name="audio-volume-muted"
	amixer set $mixer mute
	display_volume="Mute"
    else
        display_volume=$(amixer set $mixer unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
    fi
fi

if [ "$icon_name" = "" ]; then
    if [ "$display_volume" = "0" ]; then
        icon_name="audio-volume-muted"
    else
        if [ "$display_volume" -lt "33" ]; then
            icon_name="audio-volume-low"
        else
            if [ "$display_volume" -lt "67" ]; then
                icon_name="audio-volume-medium"
            else
                icon_name="audio-volume-high"
            fi
        fi
    fi
fi
notify-send -a "Sound" "Volumn:$display_volume" -i $icon_name -t 500
