#!/bin/bash -ex

# device
dev=$1
[ -z $dev ] && read dev

# wifi ssid
wifi_ssid=$2
[ -z $wifi_ssid ] && read wifi_ssid

# wifi_password
wifi_password=$3
[ -z $wifi_password ] && read wifi_password

# mount partition
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $DIR/mount.sh
mount_dev
trap umount_dev EXIT
cd $tmp_dir

# avoid wifi sleep mode (iptime n100mini)
cat <<EOF >> root/etc/modprobe.d/8192cu.conf
options 8192cu rtw_power_mgnt=0 rtw_enusbss=0
EOF

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
