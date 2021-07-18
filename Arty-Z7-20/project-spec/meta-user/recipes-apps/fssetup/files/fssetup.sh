#!/bin/sh

# Startup script
#
# Author: Paul Holmes


echo "Making mounts..."

mkdir /mnt/emmc
mkdir /mnt/emmc/mmcblk0p1
mkdir /mnt/emmc/mmcblk0p2
mkdir /mnt/flash

mount /dev/mmcblk0p1 /mnt/emmc/mmcblk0p1
mount /dev/mmcblk0p2 /mnt/emmc/mmcblk0p2
mount --bind /mnt/flash /mnt/emmc/mmcblk0p2/flash 

echo "Making mounts...done"

myEcho "Setting up FTP server(s)..."

