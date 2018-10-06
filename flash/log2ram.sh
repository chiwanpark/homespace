#!/bin/bash -ex

# device
dev=$1
[ -z $dev ] && read dev

# mount partition
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $DIR/mount.sh
mount_dev
trap umount_dev EXIT
cd $tmp_dir

# install log2ram
mkdir -p root/usr/local/bin
install -m 644 $DIR/lib/log2ram/log2ram.service root/etc/systemd/system/log2ram.service
install -m 644 $DIR/lib/log2ram/log2ram-reload.service root/etc/systemd/system/log2ram-reload.service
install -m 644 $DIR/lib/log2ram/log2ram-reload.timer root/etc/systemd/system/log2ram-reload.timer
install -m 755 $DIR/lib/log2ram/log2ram root/usr/local/bin/log2ram
install -m 644 $DIR/lib/log2ram/log2ram.conf root/etc/log2ram.conf

# enable log2ram
ln -s \
    /etc/systemd/system/log2ram.service \
    root/usr/lib/systemd/system/sysinit.target.wants/log2ram.service \

mkdir -p root/usr/lib/systemd/system/timer.target.wants
ln -s \
    /etc/systemd/system/log2ram-reload.timer \
    root/usr/lib/systemd/system/timer.target.wants/log2ram-reload.timer
