#!/usr/bin/env bash
# Docker status for polybar.
#   no arg -> whale icon + running container count (hidden when daemon is down)
#   open   -> launch lazydocker in a kitty window

case "$1" in
    open)
        exec kitty --class lazydocker -e lazydocker
        ;;
esac

# daemon down or docker missing -> print nothing (module collapses)
docker info >/dev/null 2>&1 || exit 0

running=$(docker ps -q 2>/dev/null | wc -l)

if [ "$running" -gt 0 ]; then
    echo "%{F#5577aa}󰡨%{F-} $running"
else
    echo "%{F#555555}󰡨%{F-} 0"
fi
