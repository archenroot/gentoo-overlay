# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PKG="cudnn-8.0-linux-x64-v5.1"
SRC_URI="${PKG}.tgz"

DESCRIPTION="NVIDIA cuDNN GPU Accelerated Deep Learning"
HOMEPAGE="https://developer.nvidia.com/cuDNN"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="fetch"
LICENSE="cuDNN-EULA"

S="${WORKDIR}/${PKG}"

DEPENDS=">=dev-util/nvidia-cuda-toolkit-8.0"

pkg_nofetch() {
	einfo "Please download"
	einfo "  - ${SRC_URI}"
	einfo "from ${HOMEPAGE} and place them in ${DISTDIR}"
}

src_unpack() {
	default
	mv "${WORKDIR}/cuda" "${S}"
}

src_install() {
	pushd "lib64"

	dolib.so libcudnn*.so*
	dolib.a libcudnn_static.a

	popd

	pushd "include"

	insinto /usr/include
	doins cudnn.h

	popd
}
