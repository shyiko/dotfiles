#!/bin/sh

# Enable smooth scrolling via "press button + scroll the ball" (hold-to-scroll)
/usr/bin/xinput set-prop "Kensington Slimblade Trackball" "libinput Scroll Method Enabled" 0, 0, 1
/usr/bin/xinput set-prop "Kensington Slimblade Trackball" "libinput Button Scrolling Button" 8 # top right button

# /usr/bin/xinput set-prop "Kensington Slimblade Trackball" "libinput Horizontal Scroll Enabled" 0
