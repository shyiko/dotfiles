#!/bin/sh
if xrandr | grep -cq HDMI-1-1; then
    # dGPU
    xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1080 --pos 2560x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --mode 2560x1080_60 --pos 0x0 --rotate normal --output DP2 --off
else
    # iGPU
    xrandr --output eDP-1-1 --mode 1920x1080 --pos 2560x0 --rotate normal --output DP-1-1 --off --output HDMI-1-1 --mode 2560x1080 --pos 0x0 --rotate normal --output DP-1-2 --off --output HDMI-1-2 --off
fi

~/.dotfiles/.screenlayout/hook.sh
