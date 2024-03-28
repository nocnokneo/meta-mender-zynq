FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://uboot_mender_zynq.cfg \
            "
require recipes-bsp/u-boot/u-boot-mender.inc

MENDER_UBOOT_AUTO_CONFIGURE="0"
MENDER_DTB_NAME_FORCE="image.ub"
BOOTENV_SIZE = "0x40000"

PROVIDES += "u-boot"
RPROVIDES_${PN} += "u-boot"
