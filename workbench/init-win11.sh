#!/bin/bash

virt-install \
  --name workbench-win11 \
  --ram 4096 \
  --cpu host \
  --vcpus 2 \
  --os-variant win11 \
  --disk path=/var/lib/libvirt/images/workbench-win11.qcow2,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/boot/virtio-win.iso,device=cdrom,bus=sata \
  --tpm backend.type=emulator,backend.version=2.0,model=tpm-tis \
  --features kvm_hidden=on,smm=on \
  --boot loader=/usr/share/OVMF/OVMF_CODE.secboot.fd,loader_ro=yes,loader_type=pflash,nvram_template=/usr/share/OVMF/OVMF_VARS.ms.fd \
  --network network=default,model=virtio \
  --graphics vnc,listen=0.0.0.0,port=5900,password=passw0rd \
  --cdrom /var/lib/libvirt/boot/Win11_23H2_Korean_x64v2.iso
