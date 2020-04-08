#!/usr/bin/env sh

# Kill running instances
killall -q polybar

# Start polybar
polybar --reload -c ~/.config/polybar/config.ini main &

