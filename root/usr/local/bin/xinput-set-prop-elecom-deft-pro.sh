#!/bin/sh

/usr/bin/xinput set-prop "pointer:ELECOM TrackBall Mouse DEFT Pro TrackBall" "libinput Accel Speed" -0.25
# hold-to-scroll
/usr/bin/xinput set-prop "pointer:ELECOM TrackBall Mouse DEFT Pro TrackBall" "libinput Scroll Method Enabled" 0, 0, 1
/usr/bin/xinput set-prop "pointer:ELECOM TrackBall Mouse DEFT Pro TrackBall" "libinput Button Scrolling Button" 3

# default:
# buttons
#  1 9 | 10 3 11
# 12 8 |
# scrolling
#  6 4 7
#    5

/usr/bin/xinput set-button-map $(/usr/bin/xinput list --id-only "pointer:ELECOM TrackBall Mouse DEFT Pro TrackBall") \
    9 2 3 4 5 6 7 1 1 8 2 12
#   1 2 3 4 5 6 7 8 9 10 11 12

# i.e. ->
#  9 1 | 8 3 2
# 12 1 |
