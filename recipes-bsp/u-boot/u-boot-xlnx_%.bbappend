FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://uboot_mender_zynq.cfg \
            file://uEnv.txt \
            "
require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-zynq.inc

PROVIDES += "u-boot"
RPROVIDES_${PN} += "u-boot"

