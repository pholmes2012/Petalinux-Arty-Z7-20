#
# This file is the fssetup recipe.
#

SUMMARY = "post boot filesys setup script"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://fssetup.sh \
		  "

S = "${WORKDIR}"


inherit update-rc.d

INITSCRIPT_NAME = "fssetup.sh"
INITSCRIPT_PARAMS = "start 99 S ."


do_install() {
	     install -d ${D}${sysconfdir}/init.d
	     install -d ${D}${sysconfdir}/rcS.d
	     install -m 0755 ${S}/fssetup.sh ${D}${sysconfdir}/init.d/fssetup.sh
             install -m 0755 ${S}/fssetup.sh ${D}${sysconfdir}/rcS.d/fssetup.sh		
}

FILES_${PN} += "${sysconfdir}/*"
