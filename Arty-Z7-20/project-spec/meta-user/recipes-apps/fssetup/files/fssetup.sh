#!/bin/sh

# Startup script
#
# Author: Paul Holmes


echo "Making mounts..."

mkdir /mnt/emmc
mkdir /mnt/emmc/mmcblk0p1
mkdir /mnt/emmc/mmcblk0p2
mount /dev/mmcblk0p1 /mnt/emmc/mmcblk0p1
mount /dev/mmcblk0p2 /mnt/emmc/mmcblk0p2
ln -s /mnt/emmc/mmcblk0p2/flash /mnt/flash

echo "Making mounts...done"

