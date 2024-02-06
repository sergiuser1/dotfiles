#!/usr/bin/env sh

killall -q polybar

HOST="$(hostname -s)"

case "$HOST" in
sinkpad | desks | seoj-linux0x)
    BAR="$HOST"
    ;;
*)
    BAR=default
    ;;
esac

polybar -l warning -r -c $HOME/.config/polybar/main.ini "$BAR"
