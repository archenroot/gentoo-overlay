# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 toolchain-funcs

DESCRIPTION="cwrap helps generate Lua/C wrappers to interface with C functions."
HOMEPAGE="https://github.com/torch/cwrap"
EGIT_REPO_URI="https://github.com/torch/cwrap.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc luajit"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
				luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
		virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

src_configure() {
	local mycmakeargs=(
		"-DLUADIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		dodoc README.md
	fi
}
