#!/bin/sh -e

DIR=$PWD

. "${DIR}/version.sh"
unset CC
. "${DIR}/.CC"

if [ -f ${DIR}/KERNEL/Makefile ] ; then
	cd ${DIR}/KERNEL/

	#cp -v "${DIR}/patches/debian.config" .config
	cp -v "${DIR}/patches/ref_multi_v7_defconfig" .config
	cp -v "${DIR}/patches/fragment-01-multiv7_cleanup.config" fragment-01-multiv7_cleanup.config
	cp -v "${DIR}/patches/fragment-02-multiv7_addons.config" fragment-02-multiv7_addons.config
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" olddefconfig
	ARCH=${KERNEL_ARCH} ./scripts/kconfig/merge_config.sh -m -r .config fragment-01-multiv7_cleanup.config fragment-02-multiv7_addons.config
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" olddefconfig
	cp -v .config "${DIR}/patches/defconfig"
	rm fragment-01-multiv7_cleanup.config || true
	rm fragment-02-multiv7_addons.config || true

	cd ${DIR}/
fi
