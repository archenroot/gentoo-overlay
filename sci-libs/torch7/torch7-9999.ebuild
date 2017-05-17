# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO:
# 1: libtorch.so is installed into /usr/lib64 instead of lua subdir

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Torch is a Lua-based suite for scientific computations based on multidimensional tensors."
HOMEPAGE="https://github.com/torch/torch7"
EGIT_REPO_URI="https://github.com/torch/torch7.git"

LICENSE="BSD3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+minimal cuda cudnn luajit opencl"

COMMON_DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
		luajit? ( dev-lang/luajit:2= )"
DEPEND="${COMMON_DEPEND}
	virtual/blas
	virtual/lapack
	dev-lua/luafilesystem
	dev-lua/penlight
	dev-lua/lua-cjson
	=dev-lua/torch-cwrap-9999
	=dev-lua/torch-paths-9999
	sys-devel/gcc[fortran]"
RDEPEND="${DEPEND}
	!minimal? (
		=sci-libs/torch-image-9999
		=sci-libs/torch-sys-9999
		=sci-libs/torch-nn-9999
		=sci-libs/torch-xlua-9999
		=sci-libs/torch-dok-9999
		=sci-libs/torch-optim-9999
	)
	cuda? (
		=sci-libs/torch-cutorch-9999
		=sci-libs/torch-cunn-9999
	)
	cudnn? (
		=sci-libs/torch-cudnn-9999
	)
	opencl? (
		=sci-libs/torch-cltorch-9999
		=sci-libs/torch-clnn-9999
	)"

REQUIRED_USE="cudnn? ( cuda )"

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
	mkdir -p "${D}"/usr/lib/lua/5.1 "${D}"/usr/share/lua/5.1/
	mv "${D}"/usr/lib64/libtorch.so "${D}"/usr/lib/lua/5.1/
	mv "${D}"/usr/lua/* "${D}"/usr/share/lua/5.1/
	rm -rf "${D}"/usr/lua
}
