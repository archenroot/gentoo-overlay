# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Torch module for various Lua extensions."
HOMEPAGE="https://github.com/clementfarabet/lua---ffmpeg"

EGIT_REPO_URI="https://github.com/clementfarabet/lua---ffmpeg.git"

LICENSE="BSD3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="luajit"

DEPEND=">=dev-lang/lua-5.1:=
		dev-lang/luajit:2
		=sci-libs/torch7-9999"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_BUILD_TYPE=Release"
		"-DLUADIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"-DLIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LIB $(usex luajit 'luajit' 'lua'))"
		"-DLUA_BINDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUA_INCDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_INC $(usex luajit 'luajit' 'lua'))"
		"-DLUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"-DSCRIPTS_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUALIB=`equery files luajit |grep lib64/libluajit | grep .so | awk 'NR==0; END{print}'`"
		"-DLUA=/usr/bin/luajit"
		"-DCMAKE_BUILD_TYPE=Release"
		"-DCMAKE_PREFIX_PATH=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))/.."
		"-DCMAKE_INSTALL_PREFIX=/usr"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mkdir -p "${D}"/usr/lib/lua/5.1 "${D}"/usr/share/lua/5.1
	mv "${D}"/usr/lib/* "${D}"/usr/lib/lua/5.1/
	mv "${D}"/usr/lua/* "${D}"/usr/share/lua/5.1/
	rm -rf "${D}"/usr/lua
}
