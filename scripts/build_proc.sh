#!/bin/sh
# Process build a petalinux application
#
# Copyright (C) 2021 Paul Holmes
# Author: Paul Holmes
# ---------------------------------------------
# This script builds and optionally uploads a named application
# Required arguments are the build path and application name
# Optional arguments are the IP address: "ip=#.#.#.#" for post build upload
#
# Usage: build_proc.sh [zusp path] -p [app name] ip=[IP address]


STATUS=0
SDI_MODE=0
IP=""         # Stores FTP IP address
BUILD_PATH=""
APP_NAME=""

while [ $# -gt 0 ]; do
   case $1 in
      ip=*) IP=$(echo $1 | awk -F= '{print $2}');;
      p=*)  APP_NAME=$(echo $1 | awk -F= '{print $2}');;
      *)    BUILD_PATH="$1Arty-Z7-20";;
   esac
   shift
done


if [ ! -z ${BUILD_PATH} ]; then
   echo "[build_proc.sh] Path: '${BUILD_PATH}'"
   STATUS=1
else
   echo "[build_proc.sh] FAILED no path!"
   STATUS=0
fi

if [ ! -z ${APP_NAME} ]; then
   echo "[build_proc.sh] App: ${APP_NAME}"
   STATUS=1
else
   echo "[build_proc.sh] FAILED no app name!"
   STATUS=0
fi

if [ $STATUS -eq 0 ]; then
  exit 0
fi

. ${BUILD_PATH}/build_info

APP_PATH=${BUILD_PATH}/project-spec/meta-user/recipes-apps/${APP_NAME}/files

echo -ne "[build_proc.sh] Building '${APP_NAME}'... "
CWD=${PWD}
cd ${APP_PATH}

rm *.o
rm ${APP_NAME}

export KERNEL_src=${BUILD_PATH}/build/tmp/work-shared/plnx_arm/kernel-source
export KERNEL_VERSION=4.9-xilinx-v2017.4
export CC=${GCC_HEADER}-gcc
export CXX=${GCC_HEADER}-g++
export LD=${GCC_HEADER}-ld.bfd

make


if [ -f ${APP_NAME} ]; then 
  if [ ! -z ${IP} ]; then
    ${CWD}/scripts/ftp_upload.sh ${APP_NAME} dir=/tmp ip=${IP}
  fi
  cp ${APP_NAME} ${CWD}/temp
  rm ${APP_NAME}
fi

cd ${CWD}
