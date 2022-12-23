#!/usr/bin/env sh

killall -q polybar

HOST="$(hostname -s)"

if [ "$HOST" = 'sinkpad' ]; then
    polybar -l warning -r -c $HOME/.config/polybar/main.ini thinkpad
elif [ "$HOST" = 'desks' ]; then
    polybar -l warning -r -c $HOME/.config/polybar/main.ini desks
else
    polybar -l warning -r -c $HOME/.config/polybar/main.ini thinkpad
fi
