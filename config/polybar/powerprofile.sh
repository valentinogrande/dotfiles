#!/usr/bin/env bash
# power-profiles-daemon status + cycle for polybar.
#   no arg  -> print icon for the active profile (bar display)
#   cycle   -> rotate power-saver -> balanced -> performance -> ...

icon() {
    case "$1" in
        power-saver) echo "%{F#55aa55}󰌪%{F-}" ;;   # green leaf = saver
        balanced)    echo "%{F#c0c0c0}󰗑%{F-}" ;;   # neutral
        performance) echo "%{F#cc4444}󰓅%{F-}" ;;   # red rocket
        *)           echo "%{F#555555}󰂑%{F-}" ;;
    esac
}

cur() { powerprofilesctl get 2>/dev/null; }

cycle() {
    case "$(cur)" in
        power-saver) next=balanced ;;
        balanced)    next=performance ;;
        performance) next=power-saver ;;
        *)           next=balanced ;;
    esac
    powerprofilesctl set "$next" 2>/dev/null
    command -v notify-send >/dev/null && notify-send -t 1500 "Power profile" "$next"
}

case "$1" in
    cycle) cycle ;;
    *)     icon "$(cur)" ;;
esac
