# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Object classes for Lua"
HOMEPAGE="https://github.com/torch/class"
EGIT_REPO_URI="https://github.com/torch/class.git"

LICENSE="BSD3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc luajit"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
		luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND} ${DEPEND}"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))/class"
	doins -r init.lua
	dodoc README.md
}
