xrdb -merge ~/.Xresources # terminal setup

# keybindings
xmodmap ~/.Xmodmap
setxkbmap -layout us,ru,ua -option 'grp:alt_space_toggle'
# https://superuser.com/questions/566871/how-to-map-the-caps-lock-key-to-escape-key-in-arch-linux
# See also https://github.com/Microsoft/vscode/issues/32037 (for an additional tweak to make s/CAPS_LOCK/ESC work in vscode).
setxkbmap -option caps:escape
pkill xbindkeys
xbindkeys # --nodaemon &

~/.dotfiles/root/usr/local/bin/xinput-set-prop-dell-xps-15-touchpad.sh
~/.dotfiles/root/usr/local/bin/xinput-set-prop-elecom-deft-pro.sh
~/.dotfiles/root/usr/local/bin/xinput-set-prop-elecom-huge.sh
~/.dotfiles/root/usr/local/bin/xinput-set-prop-logitech-m570.sh
~/.dotfiles/root/usr/local/bin/xinput-set-prop-logitech-mx-ergo.sh
~/.dotfiles/root/usr/local/bin/xinput-set-prop-microsoft-trackball-explorer.sh

# clipboard sync
pkill autocutsel
autocutsel &

# TIP: vscode is using pkexec for "Retry As Sudo" (sudo apt install policykit-1-gnome)
pkill polkit-gnome-authentication-agent-1
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

if [ "$(ls -l /etc/X11/xorg.conf | grep -c igpu)" -eq "1" ]; then
	# generated with `gtf 2560 1080 60`
	xrandr --newmode "2560x1080_60"  230.76  2560 2728 3000 3440  1080 1081 1084 1118  -HSync +Vsync
	xrandr --addmode HDMI1 "2560x1080_60"
elif [ "$(ls -l /etc/X11/xorg.conf | grep -c dgpu)" -eq "1" ]; then
	xrandr --setprovideroutputsource modesetting NVIDIA-0
	xrandr --auto
	nvidia-settings --config ~/.dotfiles/.nvidia-settings-rc-dgpu --load-config-only
elif [ "$(ls -l /etc/X11/xorg.conf | grep -c egpu-nvidia)" -eq "1" ]; then
	nvidia-settings --config ~/.dotfiles/.nvidia-settings-rc-egpu --load-config-only
fi

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
