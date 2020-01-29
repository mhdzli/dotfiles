#!/bin/sh

usage="usage: $0 -c {up|down} [-i increment]"
command=
increment=25

while getopts i:m:h o
do case "$o" in
    i) increment=$OPTARG;;
    h) echo "$usage"; exit 0;;
    ?) echo "$usage"; exit 0;;
esac
done

shift $(($OPTIND - 1))
command=$1

if [ "$command" = "" ]; then
    echo "usage: $0 {up|down} [increment]"
    exit 0;
fi

if [ "$command" = "up" ]; then
    light -A $increment;
fi

if [ "$command" = "down" ]; then
    light -U $increment;
fi

status=$(light | cut -d '.' -f1)
notify-send -i "nm-signal-${status}" -a "Display" "Light: ${status}%" -t 1000
