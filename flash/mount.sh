#!/bin/bash -ex

tmp_dir=$(mktemp -d)

function mount_dev {
    cd $tmp_dir

    echo $dev | grep "mmcblk"
    if [ $? -eq 0 ]; then
        p1="p1"; p2="p2";
    else
        p1="1"; p2="2";
    fi

    mkdir -p boot
    mount ${dev}${p1} boot
    trap umountboot EXIT
    mkdir -p root
    mount ${dev}${p2} root
}

function umount_dev {
    cd $tmp_dir
    umount boot || true
    umount root || true

    cd /tmp
    rm -r $tmp_dir
}
