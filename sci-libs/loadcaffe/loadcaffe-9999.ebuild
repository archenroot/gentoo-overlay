# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Load Caffe networks in Torch7."
HOMEPAGE="https://github.com/szagoruyko/loadcaffe"
EGIT_REPO_URI="https://github.com/szagoruyko/loadcaffe.git"

LICENSE="BSD2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples luajit"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
		luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
		virtual/pkgconfig
		=dev-libs/protobuf-3.1.0"
RDEPEND="${DEPEND}"

BUILD_DIR="${WORKDIR}/${P}/build"

src_prepare() {
echo "INSTALL_BIN $($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_INC $($(tc-getPKG_CONFIG) --variable INSTALL_INC $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_LIB $($(tc-getPKG_CONFIG) --variable INSTALL_LIB $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_PC $($(tc-getPKG_CONFIG) --variable INSTALL_PC $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_MAN $($(tc-getPKG_CONFIG) --variable INSTALL_MAN $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_LMOD $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_CMOD $($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
	echo "INSTALL_TOP $($(tc-getPKG_CONFIG) --variable INSTALL_TOP $(usex luajit 'luajit' 'lua'))"
	echo "`equery files luajit |grep lib64/libluajit | grep .so | awk 'NR==0; END{print}'`"
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
src_install() {
	cmake-utils_src_install
}
