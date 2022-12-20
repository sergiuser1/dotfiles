#!/usr/bin/env sh

killall -q polybar

HOST="$(hostname -s)"

if [ "$HOS" = 'thinkpad' ]; then
    polybar -l warning -r -c $HOME/.config/polybar/main.ini thinkpad
elif [ "$HOST" = 'desks' ]; then
    polybar -l warning -r -c $HOME/.config/polybar/main.ini desks
fi
