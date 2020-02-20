SRC_URI += ""

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {

	for imageType in ${KERNEL_IMAGETYPES} ; do
		if [ "${KERNEL_PACKAGE_NAME}" = "kernel" ]; then
			ln -sf ${imageType}-${KERNEL_VERSION} ${D}/${KERNEL_IMAGEDEST}/${imageType}
		fi
	done

	#cp ${D}/${KERNEL_IMAGEDEST}/fitImage-${KERNEL_VERSION} ${D}/${KERNEL_IMAGEDEST}/image.ub
}
