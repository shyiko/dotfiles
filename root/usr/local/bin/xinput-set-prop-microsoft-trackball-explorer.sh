#!/bin/sh

# Enable smooth scrolling via "press scroll wheel + scroll the ball" (hold-to-scroll)
/usr/bin/xinput set-prop "pointer:Microsoft Microsoft Trackball Explorer®" "libinput Scroll Method Enabled" 0, 0, 1
/usr/bin/xinput set-prop "pointer:Microsoft Microsoft Trackball Explorer®" "libinput Button Scrolling Button" 2 # default (by pressing scroll-wheel)

# /usr/bin/xinput set-button-map $(/usr/bin/xinput list --id-only "pointer:Microsoft Microsoft Trackball Explorer®") \
#     1 2 8 4 5 6 7 3 9 # swap button above the scroll wheel (right click) and right next to the ball (go back)

/usr/bin/xinput set-prop "pointer:Microsoft Microsoft Trackball Explorer®" "libinput Horizontal Scroll Enabled" 0
