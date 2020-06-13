#!/bin/bash
set -e

sudo apt upgrade -y

# timedatectl
# timedatectl list-timezones
sudo timedatectl set-timezone America/Los_Angeles

~/.dotfiles/apply

sudo apt purge -y snapd lxd-agent-loader cloud-init modemmanager ppp
sudo rm -f /usr/share/fonts/truetype/msttcorefonts/cour* # Courier New is hard to read (check code @ https://reactjs.org/docs/hooks-overview.html)
# TODO: https://needforbits.wordpress.com/2017/07/19/install-microsoft-windows-fonts-on-ubuntu-the-ultimate-guide/
# TODO: https://source.winehq.org/git/wine.git/tree/HEAD:/fonts (tahoma)
sudo apt purge -y fonts-noto-cjk fonts-noto-cjk-extra fonts-vlgothic xfonts-scalable

sudo apt install -y xserver-xorg-video-intel # make sure i915 is left after the purge

# systemctl list-unit-files --state=enabled --no-pager
sudo systemctl disable lighttpd.service
sudo systemctl disable motd-news.timer

# see DELL_XPS_15_9550.md
sudo systemctl enable cpupower-performance.service
sudo systemctl enable dell-xps15-9550-undervolt.service
sudo systemctl enable dell-xps15-9550-cpu-freq-after-suspend.service

# https://docs.docker.com/engine/install/linux-postinstall/
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable bluetooth.service

# dconf dump /
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.list-view default-zoom-level small
gsettings set org.gnome.nautilus.icon-view default-zoom-level small

# Workaround for "Couldn't call Modify on the PackageKit interface: no owner for PackageKit"
#
# https://wiki.archlinux.org/index.php/XDG_MIME_Applications#Variables_in_.desktop_files_that_affect_application_launch
# https://wiki.archlinux.org/index.php/default_applications
#
# Alternatively, add <policy user="shyiko">... to /etc/dbus-1/system.d/org.freedesktop.PackageKit.conf and
# `systemctl restart dbus`.
sudo sed -i 's/DBusActivatable=true/DBusActivatable=false/' /usr/share/applications/org.gnome.FontViewer.desktop

# https://github.com/ryanoasis/nerd-fonts
# Used in ~/.Xresources.
mkdir -p ~/.local/share/fonts/Unknown\ Vendor/OpenType/Inconsolata\ Nerd\ Font\ Mono
curl -sSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete%20Mono.otf" \
    -o ~/.local/share/fonts/Unknown\ Vendor/OpenType/Inconsolata\ Nerd\ Font\ Mono/Inconsolata_Nerd_Font_Mono_Regular.otf
fc-cache -f -v

mkdir -p ~/.config/Code/Dictionaries
ln -s /usr/share/hunspell/en_US.* ~/.config/Code/Dictionaries/

chmod 0700 /home/shyiko/.gnupg
curl -sSL https://keybase.io/shyiko/pgp_keys.asc | gpg --import -
gpg --card-status
gpg --edit-key 160A7A9CF46221A56B06AD64461A804F2609FD89 # type "trust", select 5 - ultimate
