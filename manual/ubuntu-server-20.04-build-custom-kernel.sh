# https://wiki.ubuntu.com/Kernel/SourceCode
# https://wiki.ubuntu.com/KernelTeam/KernelMaintenance

sudo apt-get install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache bison flex

# for tools/*
sudo apt install \
    asciidoc \
    binutils-dev \
    libaudit-dev \
    libbabeltrace-dev \
    libcap-dev \
    libdw-dev \
    libdwarf-dev \
    libelf-dev \
    libiberty-dev \
    liblzma-dev \
    libnuma-dev \
    libperl-dev \
    libpython-all-dev \
    libreadline-dev \
    libunwind-dev \
    libzstd-dev \
    python-dev-is-python2 \
    python-docutils \
    systemtap-sdt-dev

# git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/<source package>/+git/<series>
git clone git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/focal src
cd src

# $ git tag -l Ubuntu-*
# Ubuntu-5.4.0-33.37
# ...
git checkout -b 5.4.0-33.37-shyiko Ubuntu-5.4.0-33.37

git apply ~/.dotfiles/kernel-hid-apple.patch
git apply ~/.dotfiles/kernel-perf-binutils-2.34-compat.patch

cp /boot/config-`uname -r` .config
# yes '' | make oldconfigk
make oldconfig

JDIR=~/.jabba/jdk/zulu@1.8.252 LANG=C fakeroot debian/rules clean
JDIR=~/.jabba/jdk/zulu@1.8.252 LANG=C fakeroot debian/rules binary-headers binary-generic binary-perarch skipmodule=true skipabi=true














# make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-shyiko \
# do_tools=true \
# do_linux_tools=true \
# do_tools_usbip=true \
# do_tools_acpidbg=true \
# do_tools_cpupower=true \
# do_tools_perf=true \
# do_tools_perf_jvmti=true \
# do_tools_bpftool=true \
# do_tools_x86=true

# do_linux_tools=true  do_tools=true do_tools_perf_jvmti=true

# cd ..
# sudo apt install linux-image-2.6.24-rc5-custom_2.6.24-rc5-custom-10.00.Custom_i386.deb

# sudo apt install binutils-dev libreadline-dev libelf-dev libzstd-dev liblzma-dev libdwarf-dev libunwind-dev libnuma-dev libcap-dev libaudit-dev libperl-dev libpython-all-dev libdw-dev python-dev-is-python2 libgtk2.0-dev binutils-dev libiberty-dev libbabeltrace-dev systemtap-sdt-dev python-docutils asciidoc


# git apply ~/.dotfiles/kernel-perf-binutils-2.34-compat.patch


# JDIR=~/.jabba/jdk/zulu@1.8.252 LANG=C fakeroot debian/rules clean
# JDIR=~/.jabba/jdk/zulu@1.8.252 LANG=C fakeroot debian/rules binary


# JDIR=~/.jabba/jdk/zulu@1.8.252 make tools/acpi tools/bpf tools/cpupower tools/perf tools/turbostat tools/usb tools/x86_energy_perf_policy

# JDIR=~/.jabba/jdk/zulu@1.8.252 make -C tools/ cpupower_install

# # make -C tools/ <tool>_install
# JDIR=~/.jabba/jdk/zulu@1.8.252 make -C tools/ cpupower_install
# JDIR=~/.jabba/jdk/zulu@1.8.252 make prefix=/usr -C tools/ bpf_install
# # ---

#  \
#     do_tools=true \
#     do_linux_tools=true \
#     do_tools_usbip=true \
#     do_tools_acpidbg=true \
#     do_tools_cpupower=true \
#     do_tools_perf=true \
#     do_tools_perf_jvmti=true \
#     do_tools_bpftool=true \
#     do_tools_x86=true
# # ---

# git://kernel.ubuntu.com/ubuntu/ubuntu-focal.git

# ---

curl -sSLO https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.44.tar.xz
atool -xq linux-5.4.44.tar.xz
cd linux-5.4.44

# git init
# git commit -m "master" -a

cp /boot/config-$(uname -r) .config
yes '' | make oldconfig

git apply ~/.dotfiles/manual/kernel-hid-battery-quirk-apple.patch
# git apply ~/.dotfiles/manual/kernel-pre-5.4.44-perf-binutils-2.34-compat.patch

make -j $(getconf _NPROCESSORS_ONLN) deb-pkg LOCALVERSION=-shyiko
# JDIR is required to build perf_jvmti
sudo checkinstall --pkgname=linux-tools-5.4.44-shyiko --pkgversion=1 --replaces=linux-tools-common --nodoc -y --install=no \
    env JDIR=~/.jabba/jdk/zulu@1.8.252 make -C tools/ prefix=/usr \
        acpi_install \
        bpf_install \
        cpupower_install \
        perf_install \
        turbostat_install \
        x86_energy_perf_policy_install


JDIR=~/.jabba/jdk/zulu@1.8.252 make prefix=/usr \
    tools/acpi \
    tools/bpf \
    tools/cpupower \
    tools/perf \
    tools/turbostat \
    tools/usb \
    tools/x86_energy_perf_policy
