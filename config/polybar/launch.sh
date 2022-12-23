#!/usr/bin/env sh

killall -q polybar

HOST="$(hostname -s)"

case "$HOST" in
    sinkpad|desks)
        BAR="$HOST";;
    *)
        BAR=default;;
esac

polybar -l warning -r -c $HOME/.config/polybar/main.ini "$BAR"
