#!/usr/bin/env bash
# Brightness preset menu via rofi + brightnessctl

THEME="$HOME/.config/rofi/dark.rasi"

cur=$(brightnessctl -m 2>/dev/null | cut -d, -f4)

chosen=$(printf '%s\n' \
    "󰃠  100%" \
    "󰃟  75%" \
    "󰃟  50%" \
    "󰃞  25%" \
    "󰃞  10%" \
    | rofi -dmenu -i -p "Brillo ($cur)" -theme "$THEME")

[ -z "$chosen" ] && exit 0

pct=$(printf '%s' "$chosen" | grep -oE '[0-9]+%')
[ -n "$pct" ] && brightnessctl set "$pct" >/dev/null
