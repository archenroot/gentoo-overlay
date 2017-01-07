# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3 toolchain-funcs

DESCRIPTION="cwrap helps generate Lua/C wrappers to interface with C functions."
HOMEPAGE="https://github.com/torch/cwrap"
EGIT_REPO_URI="https://github.com/torch/cwrap.git"

LICENSE="BSD3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc luajit"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
				luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
		virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND} 
		 ${DEPEND}"
src_configure() {
	LUADIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	local mycmakeargs=(
                "-DLUADIR=${LUADIR}"
    )
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	if use doc; then
		dodoc README.md
	fi
}
