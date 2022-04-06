# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-vm-2

JVM_VER=${PR:1}

echo $JVM_VER

SLOT=${JVM_VER}
#https://codeload.github.com/graalvm/graalvm-ce-builds/tar.gz/refs/tags/vm-ce-21.2.0
#https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.2.0/graalvm-ce-java0-linux-amd64-21.2.0.tar.gz'
#https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.2.0/graalvm-ce-java11-linux-amd64-21.2.0.tar.gz
SRC_URI="https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${PV}/graalvm-ce-java${JVM_VER}-linux-amd64-${PV}.tar.gz
	native-image? ( https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${PV}/native-image-installable-svm-java${JVM_VER}-linux-amd64-${PV}.jar )"

DESCRIPTION="GraalVM prebuild binaries"
HOMEPAGE="https://www.graalvm.org/"
LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="~amd64"
IUSE="+gentoo-vm native-image"

RDEPEND=">=sys-libs/glibc-2.2.5:*
	sys-libs/zlib"

RESTRICT="preserve-libs splitdebug"
QA_PREBUILT="*"
S=${WORKDIR}/graalvm-ce-java${JVM_VER}-${PV}

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]]; then
		die "These binaries require a hardfloat system."
	fi
}

src_unpack() {
	unpack graalvm-ce-java${JVM_VER}-linux-amd64-${PV}.tar.gz
}

src_install() {
        if use native-image ; then
		bin/gu install -A -N -L ${DISTDIR}/native-image-installable-svm-java${JVM_VER}-linux-amd64-${PV}.jar
	fi

	local dest="/opt/${P}"
	local ddest="${ED%/}/${dest#/}"

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

        if use native-image ; then
		dosym ${dest}/bin/native-image /usr/bin/native-image
	fi

	use gentoo-vm && java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
	java-vm-2_pkg_postinst
}
