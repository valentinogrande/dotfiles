#!/usr/bin/env bash
# WiFi control menu via rofi + nmcli

THEME="$HOME/.config/rofi/dark.rasi"
menu() { rofi -dmenu -i -p "WiFi" -theme "$THEME" "$@"; }

enabled() { [ "$(nmcli -t radio wifi)" = "enabled" ]; }

networks_menu() {
    nmcli -t -f IN-USE,SIGNAL,SSID device wifi list >/dev/null 2>&1
    local list chosen ssid pass
    # format: icon  SSID  signal%   (skip empty SSIDs)
    list=$(nmcli --colors no -t -f IN-USE,SSID,SIGNAL device wifi list \
        | awk -F: '$2!="" {
            ic = ($1=="*") ? "󰤨 " : "󰤟 ";
            printf "%s %-28s %s%%\n", ic, $2, $3 }' \
        | sort -k3 -t% -nr)

    chosen=$(printf '%s\n' "$list" | menu)
    [ -z "$chosen" ] && return

    # strip leading icon + trailing signal -> SSID
    ssid=$(printf '%s' "$chosen" | sed -E 's/^[^ ]+ +//; s/ +[0-9]+%$//; s/ +$//')
    [ -z "$ssid" ] && return

    # already saved? try plain connect first
    if nmcli connection show --active | grep -qF "$ssid"; then
        nmcli connection down id "$ssid"
        return
    fi
    if nmcli -t -f NAME connection show | grep -qxF "$ssid"; then
        nmcli connection up id "$ssid" && return
    fi

    pass=$(echo "" | rofi -dmenu -password -p "Clave de $ssid" -theme "$THEME")
    if [ -n "$pass" ]; then
        nmcli device wifi connect "$ssid" password "$pass"
    else
        nmcli device wifi connect "$ssid"
    fi
}

main() {
    local state chosen
    if enabled; then state="󰖪  Apagar WiFi"; else state="󰖩  Encender WiFi"; fi

    chosen=$(printf '%s\n' \
        "󰤨  Redes" \
        "$state" \
        "󰒓  nm-connection-editor" \
        | menu)

    case "$chosen" in
        *Redes*)     enabled || nmcli radio wifi on; networks_menu ;;
        *Apagar*)    nmcli radio wifi off ;;
        *Encender*)  nmcli radio wifi on ;;
        *editor*)    nm-connection-editor & ;;
    esac
}

main
