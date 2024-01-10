#!/bin/sh

# /usr/bin/xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" "libinput Accel Speed" -0.25
# hold-to-scroll
/usr/bin/xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" "libinput Scroll Method Enabled" 0, 0, 1
/usr/bin/xinput set-prop "pointer:ELECOM TrackBall Mouse HUGE TrackBall" "libinput Button Scrolling Button" 3

# default:
# buttons
#  1 9 | 10 3 12
#    8 | 11
# scrolling
#  6 4 7
#    5

/usr/bin/xinput set-button-map $(/usr/bin/xinput list --id-only "pointer:ELECOM TrackBall Mouse HUGE TrackBall") \
    1 2 3 4 5 6 7 1 1 9 8 2 # 1..12 total
# i.e. ->
#  1 1 | 9 3 2
#    1 | 8
