#!/bin/sh
if xrandr | grep -cq HDMI-0; then
    # eGPU
    xrandr \
        --output DVI-D-0 --off \
        --output HDMI-0 --mode 2560x1080 --pos 0x0 --rotate normal \
        --output DP-0 --off \
        --output DP-1 --off \
        --output DP-2 --off \
        --output DP-3 --off \
        --output DP-4 --off \
        --output DP-5 --off
elif xrandr | grep -cq HDMI-1-1; then
    # dGPU
    xrandr \
        --output eDP-1-1 --off \
        --output HDMI-1-1 --mode 2560x1080 --pos 0x0 --rotate normal \
        --output HDMI-1-2 --off \
        --output DP-1-1 --off \
        --output DP-1-2 --off
elif xrandr | grep -cq HDMI1; then
    # iGPU
    xrandr \
        --output eDP1 --off \
        --output HDMI1 --mode 2560x1080_60 --pos 0x0 --rotate normal \
        --output HDMI2 --off \
        --output DP1 --off \
        --output DP2 --off \
        --output VIRTUAL1 --off
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
$DIR/hook.sh
