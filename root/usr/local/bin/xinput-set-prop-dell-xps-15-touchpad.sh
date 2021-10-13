#!/bin/bash

# xserver-xorg-input-synaptics
# Calculated based on
# xinput list-props "DLL06E4:01 06CB:7A13 Touchpad" | grep "Synaptics Edges"
# Format:
# right button's left/right/top/bottom middle button's left/right/top/bottom.
# https://www.onlinemictest.com/mouse-test/
xinput set-prop "DLL06E4:01 06CB:7A13 Touchpad" "Synaptics Soft Button Areas" 0 0 0 0 614 0 464 0

# xserver-xorg-input-libinput
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Drag Lock Enabled" 1

# NOTE:
# libinput does NOT implement kinetic scrolling
# https://wayland.freedesktop.org/libinput/doc/latest/faqs.html#kinetic-scrolling-does-not-work
