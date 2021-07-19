#!/bin/sh

PETALINUX_SDK_VER=2017.4
export GCC_HEADER=arm-linux-gnueabihf
export SSH_PASS=evertz

export PROJ_ROOT=${PWD}
export BUILD_ROOT=${PWD}/Arty-Z7-20
#echo "Proj root: ${PROJ_ROOT}"
#echo "Build root: ${BUILD_ROOT}"
export TEMP_PATH=${PROJ_ROOT}/temp
export SCRIPT_PATH=${PROJ_ROOT}/scripts
