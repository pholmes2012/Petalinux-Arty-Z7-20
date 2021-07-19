#!/bin/sh
# Process build a petalinux application
#
# Copyright (C) 2021 Paul Holmes
# Author: Paul Holmes
# ---------------------------------------------
# This script builds and optionally uploads a named application
# Required arguments is the application name
# Optional arguments are the IP address: "ip=#.#.#.#" for post build upload
#
# Usage: build_proc.sh [app name] ip=[IP address]

CWD=${PWD}

. ${CWD}/config/settings.sh

SDI_MODE=0
IP=""         # Stores FTP IP address
APP_NAME=""

while [ $# -gt 0 ]; do
   case $1 in
      ip=*) IP=$(echo $1 | awk -F= '{print $2}');;
      *)  APP_NAME=$1;;
   esac
   shift
done

if [ ! -z ${APP_NAME} ]; then
   echo "[build_proc.sh] App: ${APP_NAME}"
else
   echo "[build_proc.sh] FAILED no app name!"
   exit 0
fi

APP_PATH=${BUILD_ROOT}/project-spec/meta-user/recipes-apps/${APP_NAME}/files


rm ${APP_PATH}/*.o
if [ -f ${APP_PATH}/${APP_NAME} ]; then 
  rm ${APP_PATH}/${APP_NAME}
fi

export KERNEL_src=${BUILD_ROOT}/build/tmp/work-shared/plnx_arm/kernel-source
export KERNEL_VERSION=4.9-xilinx-v2017.4
export CC=${GCC_HEADER}-gcc
export CXX=${GCC_HEADER}-g++
export LD=${GCC_HEADER}-ld.bfd

echo "[build_proc.sh] Building '${APP_NAME}'... "
cd ${APP_PATH}
make
cd ${CWD}

if [ -f ${APP_PATH}/${APP_NAME} ]; then 
  if [ ! -z ${IP} ]; then
    ${SCRIPT_PATH}/ftp_upload.sh ${APP_PATH}/${APP_NAME} dir=/usr/bin ip=${IP}
  fi
  cp ${APP_PATH}/${APP_NAME} ${TEMP_PATH}
  rm ${APP_PATH}/${APP_NAME}
fi

