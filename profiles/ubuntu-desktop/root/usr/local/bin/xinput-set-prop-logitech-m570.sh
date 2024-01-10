#!/bin/sh

# Enable smooth scrolling via "press scroll wheel + scroll the ball" (hold-to-scroll)
/usr/bin/xinput set-prop "pointer:Logitech M570" "libinput Scroll Method Enabled" 0, 0, 1
/usr/bin/xinput set-prop "pointer:Logitech M570" "libinput Button Scrolling Button" 9
