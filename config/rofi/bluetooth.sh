#!/usr/bin/env bash
# Bluetooth control menu via rofi + bluetoothctl

THEME="$HOME/.config/rofi/dark.rasi"
menu() { rofi -dmenu -i -p "Bluetooth" -theme "$THEME" "$@"; }

powered() { bluetoothctl show | grep -q "Powered: yes"; }

# Find the pulse/pipewire sink for a given BT mac (mac uses _ in sink name)
bt_sink() {
    local mac="${1//:/_}"
    pactl list short sinks 2>/dev/null | awk -v m="$mac" '$2 ~ m {print $2; exit}'
}

# Set a sink as default and move all active streams to it
use_sink() {
    local sink="$1"
    [ -z "$sink" ] && return 1
    pactl set-default-sink "$sink"
    pactl list short sink-inputs | awk '{print $1}' | while read -r id; do
        pactl move-sink-input "$id" "$sink"
    done
    pactl set-sink-mute "$sink" 0
}

# Wait up to ~5s for the BT sink to appear, then make it default
use_as_output() {
    local mac="$1" sink i
    for i in 1 2 3 4 5 6 7 8 9 10; do
        sink=$(bt_sink "$mac")
        [ -n "$sink" ] && break
        sleep 0.5
    done
    use_sink "$sink"
}

# Devices menu: pick a known/nearby device, toggle its connection
devices_menu() {
    bluetoothctl --timeout 5 scan on >/dev/null 2>&1 &
    local list mac name connected line chosen
    list=$(bluetoothctl devices | while read -r _ mac name; do
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            echo "󰂱  $name  [conectado]	$mac"
        else
            echo "󰂲  $name	$mac"
        fi
    done)

    chosen=$(printf '%s\n' "$list" | cut -f1 | menu)
    [ -z "$chosen" ] && return
    mac=$(printf '%s\n' "$list" | grep -F "$chosen" | head -1 | cut -f2)
    [ -z "$mac" ] && return

    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$mac"
    else
        bluetoothctl connect "$mac" || { bluetoothctl pair "$mac" && bluetoothctl connect "$mac"; }
        # if it's an audio device, make it the default output once the sink shows up
        if bluetoothctl info "$mac" | grep -q "Audio Sink"; then
            use_as_output "$mac"
        fi
    fi
}

main() {
    local state opt chosen
    if powered; then state="󰂯  Apagar bluetooth"; else state="󰂲  Encender bluetooth"; fi

    # offer "use as output" only when a connected audio sink exists
    local out_opt="" out_mac
    out_mac=$(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}' | while read -r m; do
        bluetoothctl info "$m" | grep -q "Audio Sink" && { echo "$m"; break; }
    done)
    [ -n "$out_mac" ] && out_opt="󰓃  Usar como salida"

    chosen=$(printf '%s\n' \
        "$state" \
        "󰂱  Dispositivos" \
        ${out_opt:+"$out_opt"} \
        "󰂰  Blueman (administrar)" \
        | menu)

    case "$chosen" in
        *Apagar*)        bluetoothctl power off ;;
        *Encender*)      bluetoothctl power on ;;
        *Dispositivos*)  powered || bluetoothctl power on; devices_menu ;;
        *salida*)        use_sink "$(bt_sink "$out_mac")" ;;
        *Blueman*)       blueman-manager & ;;
    esac
}

main
