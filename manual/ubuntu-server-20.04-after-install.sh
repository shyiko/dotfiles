#!/bin/bash
set -e

sudo apt upgrade -y

sudo apt install -y linux-tools-generic lighttpd # install lighttpd here (instead of aptfile) so that we could disable the service

sudo apt purge -y --auto-remove snapd lxd-agent-loader cloud-init modemmanager ppp

# systemctl list-unit-files --state=enabled --no-pager
sudo systemctl disable lighttpd.service
sudo systemctl disable motd-news.timer

# timedatectl
# timedatectl list-timezones
sudo timedatectl set-timezone America/Los_Angeles

~/.dotfiles/apply

# see DELL_XPS_15_9550.md
sudo systemctl enable cpupower-performance.service
sudo systemctl enable dell-xps15-9550-undervolt.service
sudo systemctl enable dell-xps15-9550-cpu-freq-after-suspend.service

sudo systemctl disable vboxweb-service.service

sudo apt purge fonts-noto-cjk fonts-noto-cjk-extra fonts-vlgothic

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
curl -sSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete%20Mono.otf"
    -o ~/.local/share/fonts/Unknown\ Vendor/OpenType/Inconsolata\ Nerd\ Font\ Mono/Inconsolata_Nerd_Font_Mono_Regular.otf
fc-cache -f -v

ln -s /usr/share/hunspell/en_US.* ~/.config/Code/Dictionaries/
