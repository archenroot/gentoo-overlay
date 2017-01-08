# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-utils toolchain-funcs

DESCRIPTION="Paths manipulation library for Lua."
HOMEPAGE="https://github.com/torch/paths"
EGIT_REPO_URI="https://github.com/torch/paths.git"

LICENSE="BSD3"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
		luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND} ${DEPEND}"

src_configure() {
	local mycmakeargs=(
		"-DLUADIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"-DLIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LIB $(usex luajit 'luajit' 'lua'))"
		"-DLUA_BINDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUA_INCDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_INC $(usex luajit 'luajit' 'lua'))"
		"-DLUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"-DSCRIPTS_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUALIB=`equery files luajit |grep lib64/libluajit | grep .so | awk 'NR==0; END{print}'`"
		"-DLUA=/usr/bin/luajit"
	)
	cmake-utils_src_configure
}


