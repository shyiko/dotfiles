# Dell XPS 15 9550

ToC
<!-- generated with `cat DELL_XPS_15_9550.md | gh-md-toc -` -->
* [UEFI](#uefi)
* [Wireless / Bluetooth](#wireless--bluetooth)
* [Ethernet](#ethernet)
* [CPU](#cpu)
* [RAM](#ram)
* [Storage](#storage)
* [GPU](#gpu) ([iGPU](#igpu), [dGPU](#dgpu), [eGPU](#egpu))
    * [Steam](#steam)
* [Display](#display)
    * [HDMI](#hdmi)
    * [DisplayLink](#displaylink)
* [Keyboard](#keyboard)
    * [A column-staggered split keyboard](#a-column-staggered-split-keyboard)
    * [Wrist support](#wrist-support)
* [Touchpad](#touchpad)
    * [Magic Trackpad](#magic-trackpad)
    * [Trackball](#trackball)
* [Audio](#audio)
    * [USB DAC](#usb-dac)
* [Webcam](#webcam)
* [Card Reader](#card-reader)
* [Fingerprint Reader](#fingerprint-reader)
    * [YubiKey](#yubikey)
* [Battery](#battery)
* [Power Management](#power-management)
    * [Suspend &amp; Hibernate](#suspend--hibernate)
    * [Cooling](#cooling)

> Tested on Ubuntu 18.04 / Kernel 5.0.21 / Xorg 1.19.6 / NVIDIA 440.82.  
To rule out potential ACPI-related issues, etc. upgrade kernel to 5.0+.  

## UEFI

> <kbd>F12</kbd> when in doubt.

- Uncheck "General" -> "Advanced Boot Options" -> "Enable Legacy Option ROMs".
- Select "System Configuration" -> "SATA Operation" -> "AHCI".
- Select "Secure Boot" -> "Secure Boot Enable" -> "Disabled".
- Select "POST Behavior" -> "Fn Lock Options" -> "Lock Mode Enable/Secondary".

> You'll need to change "System Configuration" -> "SATA Operation" to "RAID" and 
"Secure Boot" -> "Secure Boot Enable" to "Enabled" if you decide to go back to Windows 10 (`\EFI\Microsoft\Boot\bootmgfw.efi`). 

I'm running version 1.9.0 of UEFI firmware (follow [these instructions](https://wiki.archlinux.org/index.php/Dell_XPS_15_9560#Manual) to upgrade if needed).

## Wireless / Bluetooth

Default DW1830 card worked fine out of the box but proved unstable in [promiscuous mode](https://en.wikipedia.org/wiki/Promiscuous_mode). 
Swaped with [Intel Dual Band Wireless-AC 8265](https://ark.intel.com/content/www/us/en/ark/products/94150/intel-dual-band-wireless-ac-8265.html) ([Amazon](https://smile.amazon.com/gp/product/B0721MLM8B/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)) (802.11ac).

<details>
<summary>Software</summary>

- network-manager-gnome
- network-manager-openconnect-gnome
- blueman (bluetooth manager)

</details>

[Troubleshooting (bluetooth)](https://wiki.archlinux.org/index.php/bluetooth).

## Ethernet

I'm using [StarTech.com - USB 3.0 to Gigabit Ethernet Adapter](https://www.startech.com/Networking-IO/usb-network-adapters/USB-3-to-Gigabit-Ethernet-NIC-Network-Adapter~USB31000S) (there is no built-in RJ45 port after all).  
Plug it in, `sudo ip link set <network_interface> up && sudo dhcpcd <network_interface>` (`<network_interface>` can be found by executing `ip link`) and you're done. 

## CPU

> [Intel Core i7-6700HQ](https://ark.intel.com/content/www/us/en/ark/products/88967/intel-core-i7-6700hq-processor-6m-cache-up-to-3-50-ghz.html/) (Skylake)

<details>
<summary>/etc/systemd/system/cpupower-performance</summary>

```
[Unit]
Description=cpupower frequency-set performance

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cpupower -c all frequency-set -g performance

[Install]
WantedBy=multi-user.target
```

</details>

<details>
<summary>/etc/systemd/system/dell-xps15-9550-cpu-freq-after-suspend.service</summary>

```
[Unit]
Description=Dell XPS 15 low cpu freq on resume workaround
After=suspend.target

[Service]
Type=oneshot
# reset "rdmsr -a 0x19a" after suspend (it's 0x0 before suspend)
ExecStart=/usr/sbin/wrmsr -a 0x19a 0xe

[Install]
WantedBy=suspend.target
```

</details>

<details>
<summary>/etc/systemd/system/dell-xps15-9550-undervolt.service</summary>

```
[Unit]
Description=Dell XPS 15 undervolting

[Service]
Type=oneshot
# https://github.com/georgewhewell/undervolt
ExecStart=/usr/local/bin/undervolt --core -150 --cache -150 --gpu -130

[Install]
WantedBy=multi-user.target
```

</details>

> PREREQUISITE: install [msr-tools](https://01.org/msr-tools/overview) and [undervolt](https://github.com/georgewhewell/undervolt).

```bash
systemctl enable cpupower-performance
systemctl enable dell-xps15-9550-cpu-freq-after-suspend
systemctl enable dell-xps15-9550-undervolt
```

<details>
<summary>Software</summary>

- [msr-tools](https://01.org/msr-tools/overview) (wrmsr & rdms)
- [undervolt](https://github.com/georgewhewell/undervolt)
- cpupower (`cpupower frequency-info`, etc) & turbostat (both are kernel "tools")
- lscpu (slightly more user-friendly than `cat /proc/cpuinfo`)

</details>

> See also https://vstinner.github.io/intel-cpus.html.

## RAM

Swapped 2 x Samsung 8GB 2133 Mhz DDR4 with 2 x [Samsung 16GB 2133 Mhz DDR4](https://smile.amazon.com/gp/product/B01CTGHP96/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1) to get 32GB total. [Intel Core i7-6700HQ](https://ark.intel.com/content/www/us/en/ark/products/88967/intel-core-i7-6700hq-processor-6m-cache-up-to-3-50-ghz.html/) supports up to 64GB so, [theoretically](https://www.reddit.com/r/Dell/comments/antbu2/xps15_9560_upgraded_to_64gb_ram/), you should be able to stuff [2 x 32GB 2133 Mhz DDR4 planks](https://smile.amazon.com/gp/product/B07ZLCC6J8/) in there ([[1]](https://www.crucial.com/store/systemscanner), [[2]](https://www.memtest86.com/)).

Disable [swap](https://wiki.archlinux.org/index.php/swap) by commenting out swap entry in `/etc/fstab`  
(reboot & check `free -h` to confirm).

## Storage

Swapped Samsung MZ-VLV512D for higher-capacity [Samsung 970 EVO 1TB](https://smile.amazon.com/gp/product/B07BN217QG/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1) (there were no issues with the original).

## GPU

### iGPU

> Intel Corporation HD Graphics 530 (rev 06)

Scored ["Terrible" on UserBanchmark](https://www.userbenchmark.com/UserRun/26584507) :).  
Cannot drive 4k at 60fps on its own (use iGPU+dGPU or eGPU to work around, if needed).

Xorg configuration show below (you may need to adjust (or simply comment out) BusID)).  
If something goes wrong (e.g. black screen on boot) - switch to a different virtual console with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F2</kbd>, check `~/.local/share/xorg/Xorg.0.log` and revert the change. 

<details>
<summary>/etc/X11/xorg.conf</summary>

```shell
# https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml

Section "ServerLayout"
    Identifier "iGPU ServerLayout"
    Screen "iGPU Screen"
    # Do not turn off the monitor.
    # https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
EndSection

Section "Screen"
    Identifier "iGPU Screen"
    Device "iGPU"
    Monitor "iGPU Monitor"
EndSection

Section "Monitor"
    Identifier "iGPU Monitor"
    # Required for Option "BlankTime", etc. above to have an effect.
    Option "DPMS" "true"
EndSection

# https://wiki.archlinux.org/index.php/intel_graphics
# Intel Corporation HD Graphics 530 (rev 06)
Section "Device"
    Identifier "iGPU"
    # `lspci | grep -i vga`, then convert hex to dec
    BusID "PCI:0:2:0"
    # Think about Driver "modesetting"?
    # See https://www.phoronix.com/scan.php?page=article&item=intel-modesetting-2017&num=3 first.
    # It's a viable options when used for
    # https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/randr14.html
    # and
    # https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/primerenderoffload.html
    # though.
    Driver "intel"
    # `man intel.4` for list of supported options.
    # Use https://www.vsynctester.com/ (or https://www.youtube.com/watch?v=5xkNy9gfKOg) to test.
    Option "TearFree" "true"
    Option "DRI" "3" # otherwise steam fails on start
EndSection
```

</details>

<details>
<summary>~/.config/i3/config</summary>

```
bindsym XF86MonBrightnessUp exec xbacklight -inc 5
bindsym XF86MonBrightnessDown exec xbacklight -dec 5
```

</details>

<details>
<summary>Software</summary>

- xbacklight ([for controlling screen brightness](https://wiki.archlinux.org/index.php/backlight))

</details>

### dGPU

> NVIDIA Corporation GM107M [GeForce GTX 960M] (rev a2)

Dell XPS 15 9550 is using [NVIDIA Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus) ([[1]](https://www.reddit.com/r/linux/comments/a2tso0/the_current_state_of_nvidia_optimus_on_linux/), [[2]](https://rpmfusion.org/Howto/Optimus)) (I recommend reading [this](https://www.dell.com/community/XPS/Hybrid-vs-Optimus-Graphics/m-p/5707789/highlight/true#M3579) if you're unsure about the implications).

A few notes that apply specifically to 9550:
- you cannot use dGPU only  
(iGPU is the one connected to the internal monitor / HDMI  (check with `ls /sys/class/drm/`))
- there is no switch in UEFI that you can use to toggle between iGPU/dGPU. It's either iGPU or iGPU+dGPU. 

... and a few words of advice:
- do not use `bumblebee` / `bbswitch`  
(`bumblebee` is unmaintainded and will only makes things harder to understand). 
- do not use `optirun` / `primusrun`.  
Both are superseded by 
[PRIME render offload](https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/primerenderoffload.html) ([[1]](https://wiki.archlinux.org/index.php/PRIME#PRIME_GPU_offloading)). It's not yet generally available, however ([on Arch you'll need Xorg >= 1.20.6-1](https://wiki.archlinux.org/index.php/PRIME)).  

Setup below is based on [Offloading Graphics Display with RandR 1.4](https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/randr14.html) (dGPU does all the work while iGPU acts as output sink). 

Install NVIDIA driver (I'm running [440.82](https://www.nvidia.com/Download/driverResults.aspx/159360/en-us) with [Vulkan 1.2 support](https://developer.nvidia.com/vulkan-driver)).

On Ubuntu 18.04:

```bash
sudo apt-get purge '*nvidia*' '*bumblebee*' '*bbswitch*'
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt install nvidia-driver-440 mesa-utils # mesa-utils contains glxgears
```

Configure

<details>
<summary>/etc/modprobe.d/nvidia.conf</summary>

```
options nvidia_drm modeset=1
```

</details>

<details>
<summary>/etc/modprobe.d/blacklist-nouveau.conf</summary>

```
blacklist nouveau
options nouveau modeset=0
```

</details>

</details>

<details>
<summary>/etc/xorg.conf.d/nvidia.conf</summary>

```shell
Section "Files"
	ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
	ModulePath "/usr/lib/xorg/modules"
EndSection
```

</details>

<details>
<summary>/etc/X11/xorg.conf</summary>

```shell
# https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml
# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/randr14.html

Section "ServerLayout"
    Identifier "dGPU ServerLayout"
    Screen "dGPU Screen"
    Inactive "iGPU"
    # Do not turn off the monitor.
    # https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
EndSection

Section "Screen"
    Identifier "dGPU Screen"
    Device "dGPU"
    Monitor "dGPU Monitor"
EndSection

Section "Monitor"
    Identifier "dGPU Monitor"
    # Required for Option "BlankTime", etc. above to have an effect.
    Option "DPMS" "true"
EndSection

# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/xconfigoptions.html
# NVIDIA Corporation GM107M [GeForce GTX 960M] (rev a2)
Section "Device"
    Identifier "dGPU"
    Driver "nvidia"
    # `lspci | grep -i nvidia`, then convert hex to dec
    BusID "PCI:1:0:0"
    Option "AllowEmptyInitialConfiguration"
    Option "ProbeAllGpus" "false"
EndSection

# https://wiki.archlinux.org/index.php/intel_graphics
# Intel Corporation HD Graphics 530 (rev 06)
Section "Device"
    Identifier "iGPU"
    # lspci | grep -i vga, then convert hex to dec
    BusID "PCI:0:2:0"
    # NOTE: xbacklight does not work with the modesetting driver (https://gitlab.freedesktop.org/xorg/xserver/issues/47).
    # You can, however, control brightness with `/sys/class/backlight/intel_backlight/brightness`.
    # See https://wiki.archlinux.org/index.php/backlight for more.
    Driver "modesetting"
    # https://manpages.debian.org/stretch/xserver-xorg-core/modesetting.4.en.html

    # You may need to add
    #
    #     xrandr --output eDP-1-1 --set "PRIME Synchronization" 1
    #
    # to ~/.xinirc if you observe "tearing".
    # Use `xrandr --verbose` to confirm.
EndSection

# This config depends on nvidia.conf.
```

</details>

```bash
sudo update-initramfs -u
# eyeball to verify
lsinitramfs /boot/initrd.img-$(uname --kernel-release) | grep nvidia
```

To save power, dGPU can be powered down via

```bash
sudo modprobe acpi_call
sudo su -c "echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call && cat /proc/acpi/call"
# NOTE: nvidia module must not be loaded or the call below will hang
sudo su -c "echo 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove"
```

### eGPU

I'm using [Gigabyte Aorus GTX 1080 Gaming Box (GV-N1080IXEB-8GD)](https://www.gigabyte.com/us/Graphics-Card/GV-N1080IXEB-8GD). 

> Depending on your setup you might want to apply [NVIDIA Graphics Firmware Update Tool for DisplayPort 1.3 and 1.4](https://www.nvidia.com/en-us/drivers/nv-uefi-update-x64/).

To get started - either disable Thunderbolt security in BIOS or add [udev](https://wiki.archlinux.org/index.php/Udev) rule:

<details>
<summary>/etc/udev/rules.d/thunderbolt.rules</summary>

```
# cat /sys/bus/thunderbolt/devices/0-0/0-1/authorized is 0 (unauthorized) by default
ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
```

</details>

> You can monitor udev events via `sudo udevadm monitor` (in case you want to fine-tune rule above). Use `sudo udevadm control --reload-rules` to reload.

Install NVIDIA driver (I'm running [440.82](https://www.nvidia.com/Download/driverResults.aspx/159360/en-us) with [Vulkan 1.2 support](https://developer.nvidia.com/vulkan-driver)).

On Ubuntu 18.04:

```bash
sudo apt-get purge '*nvidia*' '*bumblebee*' '*bbswitch*'
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt install nvidia-driver-440 mesa-utils # mesa-utils contains glxgears
```

Configure

<details>
<summary>/etc/modprobe.d/nvidia.conf</summary>

```
options nvidia_drm modeset=1
```

</details>

<details>
<summary>/etc/modprobe.d/blacklist-nouveau.conf</summary>

```
blacklist nouveau
options nouveau modeset=0
```

</details>

</details>

<details>
<summary>/etc/xorg.conf.d/nvidia.conf</summary>

```
Section "Files"
	ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
	ModulePath "/usr/lib/xorg/modules"
EndSection
```

</details>

<details>
<summary>/etc/X11/xorg.conf</summary>

```
# https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml

Section "ServerLayout"
    Identifier "eGPU NVIDIA ServerLayout"
    Screen "eGPU NVIDIA Screen"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
EndSection

Section "Screen"
    Identifier "eGPU NVIDIA Screen"
    Device "eGPU NVIDIA"
    Monitor "eGPU NVIDIA Monitor"
EndSection

Section "Monitor"
    Identifier "eGPU NVIDIA Monitor"
    # https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
    Option "DPMS" "true"
EndSection

# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/xconfigoptions.html
# NVIDIA Corporation GP104 [GeForce GTX 1080] (rev ff)
Section "Device"
    Identifier "eGPU NVIDIA"
    Driver "nvidia"
    # lspci | grep -i nvidia, then convert hex to dec
    BusID "PCI:11:0:0"
    Option "AllowEmptyInitialConfiguration"
    Option "AllowExternalGpus"
    Option "ProbeAllGpus" "false"
    # Use `nvidia-settings --config ~/.nvidia-settings-rc-custom --load-config-only` instead.
    # Option "ForceFullCompositionPipeline" "on"
EndSection

# This config depends on nvidia.conf.
```

</details>

<details>
<summary>~/.nvidia-settings-rc-egpu</summary>

```
# This file is loaded by `nvidia-settings --config ~/.nvidia-settings-rc-egpu --load-config-only` (from ~/.xinitrc).
# See `nvidia-settings --help` for more.

[gpu:0]/GPUPowerMizerMode=1
CurrentMetaMode=DPY-1: 1920x1080 @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}
```

> `GPUPowerMizerMode=1` is equivalent to changing "PowerMizer" -> "Preferred Mode" to "Prefer Maximum Performace" in `nvidia-settings`.
See https://nzeid.net/linux-global-nvidia-settings for more.

</details>

<details>
<summary>~/.xinitrc</summary>

```
# apply ~/.nvidia-settings-rc-custom
nvidia-settings --config ~/.nvidia-settings-rc-custom --load-config-only
```

</details>

```bash
sudo update-initramfs -u
# eyeball to verify
lsinitramfs /boot/initrd.img-$(uname --kernel-release) | grep nvidia
```

> See also https://egpu.io/.

### Steam

In order to play Windows-only titles on Linux:
- Check "Settings" -> "Steam Play" -> "Enable Steam Play for all other titles".
- Right Click on a Windows-only title in your library -> "Properties..." -> "Set Launch Options" -> `PROTON_USE_WINED3D=1 %command%` ([[1]](https://github.com/ValveSoftware/Proton#runtime-config-options)).

If you have `ForceCompositionPipeline` on (as in `~/.nvidia-settings-rc-custom` shown above) - disable VSync in the game.

## Display

<details>
<summary>~/.config/i3/config</summary>

```
exec --no-startup-id redshift
exec --no-startup-id safeeyes
```

</details>

<details>
<summary>Software</summary>

- [displaycal](https://displaycal.net/) (color calibration [how-to](https://www.reallinuxuser.com/how-to-color-calibrate-your-monitor-in-linux/))
- [redshift](http://jonls.dk/redshift/)
- [safeeyes](https://slgobinath.github.io/SafeEyes/)

</details>

### HDMI

Works out of the box.  
Use xrandr/[arandr](https://christian.amsuess.com/tools/arandr/) to configure.

[Troubleshooting](https://wiki.archlinux.org/index.php/Xrandr).

### DisplayLink

Needs [driver](https://www.displaylink.com/downloads/ubuntu) but otherwise works.  
Use xrandr/[arandr](https://christian.amsuess.com/tools/arandr/) to configure.

[Troubleshooting](https://wiki.archlinux.org/index.php/DisplayLink).

## Keyboard

### A column-staggered split keyboard

While built-in keyboard works fine, for better ergonomics, I'd highly recommend getting a column-staggered split keyboard, e.g. [ergodox](https://ergodox-ez.com/), [corne](https://github.com/foostan/crkbd) ([build log](CORNE.md)), etc.

> See also https://www.reddit.com/r/MechanicalKeyboards/.

### Wrist support

I'm using a pair of [jelbows](https://smile.amazon.com/gp/product/B01JNKOB7A/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1).  

## Touchpad

I'm using synaptics driver as cursor would occasionally jump all over the place while on libinput.

<details>
<summary>/etc/X11/xorg.conf.d/touchpad.conf</summary>

```
Section "InputClass"
    Identifier "Dell XPS 15 9550 Touchpad"
    MatchIsTouchpad "on"
    # xinput list
    MatchProduct "DLL06E4:01 06CB:7A13 Touchpad"
    # https://wiki.archlinux.org/index.php/Touchpad_Synaptics
    # https://www.x.org/archive/X11R7.5/doc/man/man4/synaptics.4.html
    Driver "synaptics"
    # Enable natural scrolling (use `synclient VertScrollDelta=-30` to test).
    # Option "VertScrollDelta" "-30"
    # Disable tap-to-click.
    Option "MaxTapTime" "0"
    Option "TapButton1" "0"
    Option "TapButton2" "0"
    Option "TapButton3" "0"
EndSection
```

</details>

<details>
<summary>~/.xinitrc</summary>

```
# Calculated based on
# xinput list-props "DLL06E4:01 06CB:7A13 Touchpad" | grep "Synaptics Edges"
# Format:
# right button's left/right/top/bottom middle button's left/right/top/bottom.
# https://www.onlinemictest.com/mouse-test/
xinput set-prop "DLL06E4:01 06CB:7A13 Touchpad" "Synaptics Soft Button Areas" 0 0 0 0 614 0 464 0
```

</details>

> See also https://wiki.archlinux.org/index.php/Dell_XPS_15_9550#Touchpad (gestures support).

### Magic Trackpad

[Magic Trackpad](https://en.wikipedia.org/wiki/Magic_Trackpad) works fine but connection loss increases the more batteries are discharged ([bug report](https://bugzilla.kernel.org/show_bug.cgi?id=103631)). Recompiling kernel with `CONFIG_HID_BATTERY_STRENGTH=n` fixes the problem at the expense of less stable pairing.  

### Trackball

For better ergonomics, try 
- [Logitech M570](https://www.trackballmouse.org/logitech-wireless-trackball-m570/) (I got mine for less than 10$ from https://www.letgo.com/ and I love it) 
- [Logitech MX Ergo Plus](https://www.trackballmouse.org/logitech-mx-ergo-wireless-trackball/)
- or one of the [many other great options](https://www.trackballmouse.org/) (check also [r/trackballs](https://www.reddit.com/r/Trackballs/)).

## Audio

>  Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)

Built-in speakers/microphone work but plugging anything into headphone jack kills all the audio (the only reliable way to restore things - disconnect the battery, wait 30s and connect it back in (rebooting does not help; `alsactl restore`, suspend/resume may or may not help)).  
I'm using USB DAC as a workaround (see below).

<details>
<summary>~/.config/pulse/daemon.conf</summary>

```
# Configuration file for the PulseAudio daemon. 
#
# Use 
# - `pulseaudio --dump-conf` to show currently loaded configuration
# - `pulseaudio -k` to restart pulse-daemon
#
# See pulse-daemon.conf(5) for more information.

avoid-resampling = yes
flat-volumes = no
```

</details>

<details>
<summary>~/.config/i3/config</summary>

```
# use `xev` or `xmodmap -pke` to determine key alias
bindsym XF86AudioMute exec --no-startup-id ~/.dotfiles/bin/volumectl toggle
bindsym XF86AudioLowerVolume exec --no-startup-id ~/.dotfiles/bin/volumectl down
bindsym XF86AudioRaiseVolume exec --no-startup-id ~/.dotfiles/bin/volumectl up
```

</details>

### USB DAC

[AudioQuest DragonFly Black v1.5](https://www.audioquest.com/dacs/dragonfly/dragonfly-black) works perfectly.  
I'm using it together with [beyerdynamic CUSTOM Studio](https://europe.beyerdynamic.com/custom-studio.html) (80 Ohms, closed) headphones. 

Grab FLACs to test from http://www.2l.no/hires/.

<details>
<summary>Software</summary>

- spotify
- [idagio.com](https://www.idagio.com/) (classical music)
- pavucontrol (volume control)
- [volnoti](https://wiki.archlinux.org/index.php/Volnoti) (volume notification daemon)
- [playerctl](https://github.com/altdesktop/playerctl) (to control Spotify)
- [vlc](https://www.videolan.org/vlc/index.html)
- [audacity](https://www.audacityteam.org/)
- [gnome-sound-recorder](https://wiki.gnome.org/Apps/SoundRecorder)
- [spek](http://spek.cc/)

</details>

## Webcam

Works out of the box.

<details>
<summary>Software</summary>

- [cheese](https://wiki.gnome.org/Apps/Cheese)

</details>

## Card Reader

> Realtek RTS525A PCI Express Card Reader

Works out of the box.  
I'm using it for always-plugged-in low-profile [BaseQi - Ninja Stealth Drive](https://shop.baseqi.com/products/ninja-stealth-drive-for-dell-xps?utm_source=Facebook&utm_medium=landing&utm_campaign=bottom_dellxps&variant=26673590081).

<details>
<summary>Software</summary>

- [restic](https://github.com/restic/restic) (for backups)

</details>

## Fingerprint Reader

... or the lack of one :)  
See below.

### YubiKey

> I'm using YubiKey 4C (there is a newer [YubiKey 5C](https://www.yubico.com/product/yubikey-5c)).  

[YubiKey](https://www.yubico.com/why-yubico/for-developers/) is not just for U2F, passwordless [ssh/gpg](https://github.com/drduh/YubiKey-Guide), etc.  You can also use it as a poor man's replacement for fingerpring reader (e.g. you can [configure PAM](https://unix.stackexchange.com/questions/353541/i3-locking-screen-with-2-factor-authentication) to log you in when YubiKey is inserted). 

<details>
<summary>/etc/pam.d/i3lock</summary>

```
# PAM configuration file for the i3lock screen locker. 
# By default, it includes the 'login' configuration file (see /etc/pam.d/login).

auth sufficient pam_yubico.so mode=challenge-response
auth include login
```

</details>

<details>
<summary>Software</summary>

- ykpamcfg (libpam-yubico)
- [ykman / ykman-gui](https://github.com/Yubico/yubikey-manager#installation)
- seahorse
- pinentry-curses / pinentry-gtk2

</details>

> See also [yubico's Linux Login Guide - Challenge Response](https://support.yubico.com/support/solutions/articles/15000011355-ubuntu-linux-login-guide-challenge-response)

## Battery

> 4GVGH

Sooner or later it will fail/swell :) Look for [4GVGH 84wh](https://smile.amazon.com/gp/product/B084GVRWS8/ref=ppx_yo_dt_b_asin_title_o08_s00?ie=UTF8&psc=1) when it does. 6GTPY 97wh from 9560 is no better in this regard so don't waste you money (like I did).   

If you care about battery life - disabling dGPU can potentially save a lot of power.  
Aside from that, [powertop](https://wiki.archlinux.org/index.php/Powertop) can help optimize even further.

## Power Management

### Suspend & Hibernate

<details>
<summary>/etc/systemd/sleep.conf</summary>

```shell
# https://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface#Power_states
# https://www.kernel.org/doc/html/latest/admin-guide/pm/sleep-states.html

[Sleep]
# "Suspend to RAM"
SuspendState=mem

# Uncomment if you decide to enable "Hibernation"
# See https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate before you do, though (you'll need a swap partition or file)
# HibernateState=disk
# HibernateMode=shutdown
```

</details>

### Cooling

Instructions on how to repaste CPU & GPU dies can be found [here](https://www.ultrabookreview.com/14875-fix-throttling-xps-15/).

<details>
<summary>Software</summary>

- `sensors` (for CPU temp)
- `nvidia-smi` (for GPU temp)

</details>

> See also [Dell XPS 15 9560/9570 Arch wiki page](https://wiki.archlinux.org/index.php/Dell_XPS_15_9560#Fan_and_temperature_monitoring_and_control).