#!/bin/bash

nc -knl -p 9 -u |
 stdbuf -o0 xxd -c 6 -p |
 stdbuf -o0 uniq |
 stdbuf -o0 grep -v 'ffffffffffff' |
 while read ; do
  mac="${REPLY:0:2}:${REPLY:2:2}:${REPLY:4:2}:${REPLY:6:2}:${REPLY:8:2}:${REPLY:10:2}"
  for i in $(virsh --connect=qemu:///system list --all --name); do
    vmmac=$(virsh --connect=qemu:///system dumpxml $i | grep "mac address" | awk -F\' '{ print $2}')
    if [ $vmmac = $mac ]; then
      echo $mac;
      echo $i;
      virsh --connect=qemu:///system start $i
    fi
  done
done

