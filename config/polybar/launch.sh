#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Launch polybar on all monitors
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar main 2>&1 | tee -a /tmp/polybar-$m.log & disown
    done
else
    polybar main 2>&1 | tee -a /tmp/polybar.log & disown
fi
