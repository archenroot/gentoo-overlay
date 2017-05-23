# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Torch module for CUDA."
HOMEPAGE="https://github.com/torch/cutorch"
EGIT_REPO_URI="https://github.com/torch/cutorch.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+luajit +cuda"

DEPEND=">=dev-lang/lua-5.1:=
		dev-lang/luajit:2
		=sci-libs/torch7-9999
		>=dev-util/nvidia-cuda-toolkit-8.0
		cuda? ( >=sci-libs/magma-2.2.0 )"
RDEPEND="${DEPEND}"
CMAKE_VERBOSE="ON"
src_configure() {
	addwrite /dev
	local mycmakeargs=(
		"-DLUADIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"-DLIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LIB $(usex luajit 'luajit' 'lua'))"
		"-DLUA_BINDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUA_INCDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_INC $(usex luajit 'luajit' 'lua'))"
		"-DLUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"-DSCRIPTS_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_BIN $(usex luajit 'luajit' 'lua'))"
		"-DLUALIB=`equery files luajit |grep lib64/libluajit | grep .so | awk 'NR==0; END{print}'`"
		"-DLUA=/usr/bin/luajit"
		"-DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda"
		"-DMAGMA_INCLUDE_DIR=/usr/include/magma/"
	)

	cmake-utils_src_configure
}

src_install() {
	rm -f /dev/nvidia-uvm

	cmake-utils_src_install
	mkdir -p "${D}"/usr/lib/lua/5.1 "${D}"/usr/share/lua/5.1/
	mv "${D}"/usr/lib/libcutorch.so "${D}"/usr/lib/lua/5.1/
	mv "${D}"/usr/lua/* "${D}"/usr/share/lua/5.1/
	rm -rf "${D}"/usr/lua

}
