#!/bin/sh

# Firmware archive FTP process upload script.
#
# Copyright (C) 2021 Paul Holmes
# Author: Paul Holmes
# ---------------------------------------------
# This script performs an FTP based upload
#
# Usage: ftp_upload.sh [filepath] dir=[dest path] ip=[ip address]

CWD=${PWD}

. ${CWD}/config/settings.sh

# Parse command line arguments
FILE=""       # Image name must be passed as an argument
DSTDIR="/tmp" # destination sub-directory
IP=""         # Stores FTP IP address
VERBATIM="no"

while [ $# -gt 0 ]; do
   case $1 in
      ip=*)
       IP=$(echo $1 | awk -F= '{print $2}')
       ;;
      dir=*)
       DSTDIR=$(echo $1 | awk -F= '{print $2}')
       ;;
      *)
       FILE=${1}
       ;;
   esac
   shift
done

echo "[ftp_upload.sh] ${FILE} ${DSTDIR} ${IP}"

# Extract directory and image names
# FILE=$(basename ${FILE})
# echo $SRCDIR
# echo $DSTDIR
# echo $FILE

# FTP the executable to the specified IP address
if [ ! -z ${IP} -a ! -z ${FILE} -a -f ${FILE} ]; then
   USER=root
   
   echo "FTP proof" > ~/_ftp_proof.txt
   chmod +x ${FILE}
   ftp -n ${IP} <<SCRIPT
   user $USER $SSH_PASS
   cd ${DSTDIR}
   lcd $(dirname ${FILE})
   put $(basename ${FILE})
   put ~/_ftp_proof.txt ./_ftp_proof.txt
   get _ftp_proof.txt
   del _ftp_proof.txt
   quit
SCRIPT
   rm ~/_ftp_proof.txt
   if [ -f $(dirname ${FILE})/_ftp_proof.txt ]; then
     sshpass -p ${SSH_PASS} ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${IP} bash -s << EOF
      cd ${DSTDIR}
      chmod +x $(basename ${FILE}) 
EOF
     rm -f $(dirname ${FILE})/_ftp_proof.txt
     echo -e "[ftp_upload.sh:INFO] FTP Success."
     exit 0
   fi
   echo -e "[ftp_upload.sh:ERROR] FTP Failed. $(basename ${FILE})"
   exit 1
else
   # Failed
   echo -e "[ftp_upload.sh:ERROR] Bad parameter(s)."
   exit 1
fi
