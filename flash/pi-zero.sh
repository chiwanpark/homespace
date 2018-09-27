#!/bin/sh -exu
dev=$1
wifi_ssid=$2
wifi_password=$3
hostname=$4

# decide partition suffix
echo $dev | grep "mmcblk"
if [ $? -eq 0 ]; then
    p1="p1"; p2="p2";
else
    p1="1"; p2="2";
fi

# create directory for mount
tmp_dir=$(mktemp -d)
cd $tmp_dir

function umountboot {
    umount boot || true
    umount root || true

    rm -r $tmp_dir
}

archive=/tmp/ArchLinuxARM-rpi-latest.tar.gz

# download ArchLinux ARM archive
url=http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
if [ ! -f $archive ]; then
    curl -L -o $archive $url
fi

# partition SD card
parted -s $dev mklabel msdos
parted -s $dev mkpart primary fat32 1 128
parted -s $dev mkpart primary ext4 128 -- -1
mkfs.vfat ${dev}${p1}
mkfs.ext4 -F ${dev}${p2}

# mount partitions
mkdir -p boot
mount ${dev}${p1} boot
trap umountboot EXIT
mkdir -p root
mount ${dev}${p2} root

# unpack the archive to SD card
bsdtar -xpf $archive -C root
sync
mv root/boot/* boot

# GPU memory configuration
sed -i 's/gpu_mem=64/gpu_mem=16/g' boot/config.txt

# hostname configuration
echo $hostname > root/etc/hostname

# WiFi configuration
cat <<EOF >> root/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF
wpa_passphrase "${wifi_ssid}" "${wifi_password}" > root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
ln -s \
    /usr/lib/systemd/system/wpa_supplicant@.service \
    root/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
