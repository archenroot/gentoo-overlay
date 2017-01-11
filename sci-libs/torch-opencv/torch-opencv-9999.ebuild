# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-utils flag-o-matic

DESCRIPTION="Torch module for neural networks."
HOMEPAGE="https://github.com/VisionLabs/torch-opencv"
EGIT_REPO_URI="https://github.com/archenroot/torch-opencv.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cuda -tests"

DEPEND=">=dev-lang/lua-5.1:=
		dev-lang/luajit:2
		virtual/blas
		virtual/lapack
		=sci-libs/torch7-9999
		cuda? ( sci-libs/torch-cutorch )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CUDA="$(usex cuda)"
		-DBUILD_TESTS="$(usex tests)"
		"-DLUADIR=/usr/lib/lua/5.1"
		"-DLUADIR=/usr/share/lua/5.1"
		"-DLIBDIR=/usr/lib/lua/5.1"
		"-DLUA_BINDIR=/usr/bin"
		"-DLUA_INCDIR=/usr/include/luajit-2.0"
		"-DLUA_LIBDIR=/usr/lib"
		"-DLUALIB=/usr/lib/libluajit-5.1.so"
		"-DLUA=/usr/bin/luajit"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mkdir -p "${D}"/usr/lib/lua/5.1 "${D}"/usr/share/lua/5.1/
        mv "${D}"/usr/lib/lib*.so "${D}"/usr/lib/lua/5.1/
        mv "${D}"/usr/lua/* "${D}"/usr/share/lua/5.1/
        rm -rf "${D}"/usr/lua
}
