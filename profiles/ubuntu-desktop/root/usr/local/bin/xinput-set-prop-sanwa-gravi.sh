#!/bin/sh

# Enable smooth scrolling via "press scroll wheel + scroll the ball" (hold-to-scroll)
/usr/bin/xinput set-prop "pointer:Nordic 2.4G Wireless Receiver Mouse" "libinput Scroll Method Enabled" 0, 0, 1

/usr/bin/xinput set-prop "pointer:Nordic 2.4G Wireless Receiver Mouse" "libinput Horizontal Scroll Enabled" 0
/usr/bin/xinput set-prop "pointer:Nordic 2.4G Wireless Receiver Mouse" "libinput Accel Speed" -0.85
