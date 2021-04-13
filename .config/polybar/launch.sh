#!/usr/bin/env sh

# Kill running instances
killall -q polybar

# Start polybar
if pgrep -x bspwm; then
    polybar --reload -c ~/.config/polybar/config_bspwm.ini main
else
    polybar --reload -c ~/.config/polybar/config.ini main
fi

