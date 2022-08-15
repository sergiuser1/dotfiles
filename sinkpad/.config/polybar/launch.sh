#!/usr/bin/env sh

killall -q polybar
polybar -l warning -r -c $HOME/.config/polybar/config.ini main
