#!/usr/bin/env bash

chosen=$(echo -e "  Lock\n  Logout\n  Reboot\n  Shutdown" | rofi -dmenu -p "Power" -theme ~/.config/rofi/dark.rasi -lines 4)

case "$chosen" in
    *Lock)     i3lock -c 000000 ;;
    *Logout)   i3-msg exit ;;
    *Reboot)   systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
esac
