#!/bin/bash -ex

# image (0, 1, 2, 3)
image=$1
[ -z $image ] && read image 
[ $image -eq 0 ] && image=ArchLinuxARM-rpi-latest.tar.gz
[ $image -eq 1 ] && image=ArchLinuxARM-rpi-latest.tar.gz
[ $image -eq 2 ] && image=ArchLinuxARM-rpi-2-latest.tar.gz
[ $image -eq 3 ] && image=ArchLinuxARM-rpi-3-latest.tar.gz

host=http://os.archlinuxarm.org/os
if [ ! -f /tmp/$image ]; then
    curl -L -o /tmp/$image $host/$image
fi

# device
dev=$2
[ -z $dev ] && read dev

# partition and format SD card
echo $dev | grep "mmcblk"
if [ $? -eq 0 ]; then
    p1="p1"; p2="p2";
else
    p1="1"; p2="2";
fi
parted -s $dev mklabel msdos
parted -s $dev mkpart primary fat32 1 128
parted -s $dev mkpart primary ext4 128 -- -1
mkfs.vfat ${dev}${p1}
mkfs.ext4 -F ${dev}${p2}

# mount partition
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $DIR/mount.sh
mount_dev
trap umount_dev EXIT

# unpack the archive to SD card
cd $tmp_dir
bsdtar -xpf /tmp/$image -C root
sync
mv root/boot/* boot

# GPU memory configuration
sed -i 's/gpu_mem=64/gpu_mem=16/g' boot/config.txt
