#!/bin/sh
if xrandr | grep -cq HDMI-1-1; then
    # dGPU
    xrandr \
        --output eDP-1-1 --mode 1920x1080 --pos 0x0 --rotate normal \
        --output HDMI-1-1 --off \
        --output HDMI-1-2 --off \
        --output DP-1-1 --off \
        --output DP-1-2 --off
elif xrandr | grep -cq HDMI1; then
    # iGPU
    xrandr \
        --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal \
        --output HDMI1 --off \
        --output HDMI2 --off \
        --output DP1 --off \
        --output DP2 --off \
        --output VIRTUAL1 --off
fi

~/.dotfiles/.screenlayout/hook.sh
