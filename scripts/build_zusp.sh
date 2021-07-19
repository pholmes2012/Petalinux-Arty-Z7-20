#!/bin/sh
# Build PetaLinux project script
#
# Author: Paul Holmes
#
# This script builds a petalinux project

START_TIME=`date +%s`

CWD=${PWD}

. ${CWD}/config/settings.sh

IP=""         # Stores FTP IP address
while [ $# -gt 0 ]; do
   case $1 in
      ip=*) IP=$(echo $1 | awk -F= '{print $2}');;
   esac
   shift
done

echo "Build path: ${BUILD_ROOT}"

cd ${BUILD_ROOT}
# petalinux-build -x distclean
petalinux-build
petalinux-package --boot --force --fsbl images/linux/zynq_fsbl.elf --fpga images/linux/Arty_Z7_20_wrapper.bit --u-boot
cd ${CWD}

END_TIME=`date +%s`
RUN_TIME=$((END_TIME-START_TIME))
echo "Build Time taken: ${RUN_TIME} seconds"

if [ ! -z ${IP} ]; then
  echo "[build_zusp.sh:INFO] uploading..."
  ${SCRIPT_PATH}/ftp_upload.sh ${BUILD_ROOT}/images/linux/BOOT.BIN dir=/mnt/emmc/mmcblk0p1 ip=${IP}
  ${SCRIPT_PATH}/ftp_upload.sh ${BUILD_ROOT}/images/linux/image.ub dir=/mnt/emmc/mmcblk0p1 ip=${IP}
  # SSH session
  echo "[build_zusp.sh:INFO] sshpass -p ${SSH_PASS} ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${IP}"
  sshpass -p ${SSH_PASS} ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${IP} bash -s << EOF
    sync
EOF
echo "[build_zusp.sh:INFO] uploaded."
fi
