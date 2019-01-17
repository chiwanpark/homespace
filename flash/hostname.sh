#!/bin/bash -ex

# device
dev=$1
[ -z $dev ] && read dev

# hostname
hostname=$2
[ -z $hostname ] && read hostname

# mount partition
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $DIR/mount.sh
mount_dev
trap umount_dev EXIT
cd $tmp_dir

# hostname configuration
echo $hostname > root/etc/hostname
