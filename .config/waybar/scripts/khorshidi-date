#!/usr/bin/env sh

text=$(pcal -t | cut -d'-' -f3)
alt=$(pcal -t)
tooltip=$(pcal -m | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')

printf '{"text": "%s", "alt": "%s", "tooltip": "%s"}\n' "$text" "$alt" "$tooltip"
