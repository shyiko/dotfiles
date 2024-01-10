#!/bin/sh

# Enable smooth scrolling via "press scroll wheel + scroll the ball"
/usr/bin/xinput set-prop "pointer:Logitech MX Ergo" "libinput Scroll Method Enabled" 0, 0, 1
/usr/bin/xinput set-prop "pointer:Logitech MX Ergo" "libinput Accel Speed" 0.75
# `xev | grep button`
#
# 1 - left
# 2 - middle (scrollwheel)
# 3 - right
# 6 - scrollwheel left (also sent on "scroll button" + trackball)
# 7 - scrollwheel right (also sent on "scroll button" + trackball)
# 8 - down
# 9 - up
/usr/bin/xinput set-prop "pointer:Logitech MX Ergo" "libinput Button Scrolling Button" 9

# To speed up scroll you'll ned to patch libinput
#
# e.g. LIBINPUT_POINTER_AXIS_SCROLL_VERTICAL * 1.75 in gitlab.freedesktop.org/libinput/libinput/src/libinput.c
# https://wayland.freedesktop.org/libinput/doc/latest/building.html
#
# (context - https://unix.stackexchange.com/a/510981/372227)

# You may also want to create ~/.xbindkeysrc
#
# "xvkbd -text "\[Alt]\[Left]""
#    alt + b:6
# "xvkbd -text "\[Alt]\[Right]""
#    alt + b:7
