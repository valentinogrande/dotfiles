#!/usr/bin/env bash
# Bluetooth status for polybar. Icon reflects power/connection state.

if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    echo "%{F#555555}󰂲%{F-}"   # off
    exit
fi

count=$(bluetoothctl devices Connected 2>/dev/null | grep -c "^Device")
# fallback for older bluetoothctl without "devices Connected"
if [ "$count" -eq 0 ]; then
    count=$(bluetoothctl devices | while read -r _ mac _; do
        bluetoothctl info "$mac" | grep -q "Connected: yes" && echo x
    done | grep -c x)
fi

if [ "$count" -gt 0 ]; then
    echo "%{F#5577aa}󰂱%{F-} $count"   # connected
else
    echo "%{F#c0c0c0}󰂯%{F-}"          # on, idle
fi
