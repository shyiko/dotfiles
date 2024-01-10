xrdb -merge ~/.Xresources # terminal setup

# keybindings
xmodmap ~/.Xmodmap
setxkbmap -layout us,ru,ua -option 'grp:alt_space_toggle'
# https://superuser.com/questions/566871/how-to-map-the-caps-lock-key-to-escape-key-in-arch-linux
# See also https://github.com/Microsoft/vscode/issues/32037 (for an additional tweak to make s/CAPS_LOCK/ESC work in vscode).
setxkbmap -option caps:escape
pkill xbindkeys
xbindkeys # --nodaemon &

/usr/local/bin/xinput-set-prop-dell-xps-15-touchpad.sh
/usr/local/bin/xinput-set-prop-elecom-deft-pro.sh
/usr/local/bin/xinput-set-prop-elecom-huge.sh
/usr/local/bin/xinput-set-prop-kensington-slimblade.sh
/usr/local/bin/xinput-set-prop-logitech-m570.sh
/usr/local/bin/xinput-set-prop-logitech-mx-ergo.sh
/usr/local/bin/xinput-set-prop-logitech-performance-mx.sh
/usr/local/bin/xinput-set-prop-microsoft-trackball-explorer.sh
/usr/local/bin/xinput-set-prop-sanwa-gravi.sh

# clipboard sync
pkill autocutsel
autocutsel &

# TIP: vscode is using pkexec for "Retry As Sudo" (sudo apt install policykit-1-gnome)
pkill polkit-gnome-authentication-agent-1
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

for f in ~/.xinitrc.d/*; do
    "$f"
done

# compositor
pkill compton
/usr/bin/compton -CGfb -D 4 -I 0.03

# https://github.com/acrisci/playerctl/issues/51#issuecomment-431921919
exec dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id) i3

# # Workaround for GTK apps slow start https://bbs.archlinux.org/viewtopic.php?id=230036
# # `systemctl --user status xdg-desktop-portal-gtk.service` to confirm

# $ cat /usr/lib/systemd/user/xdg-desktop-portal-gtk.service
# [Unit]
# Description=Portal service (GTK+/GNOME implementation)
#
# [Service]
# Type=dbus
# BusName=org.freedesktop.impl.portal.desktop.gtk
# ExecStart=/usr/libexec/xdg-desktop-portal-gtk
# Environment=DISPLAY=:0
