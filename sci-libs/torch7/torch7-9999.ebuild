# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Torch is a Lua-based suite for scientific computations based on multidimensional tensors."
HOMEPAGE="https://github.com/torch/torch7"
EGIT_REPO_URI="https://github.com/torch/torch7.git"

LICENSE="BSD3"
SLOT="0"
KEYWORDS=""
IUSE="minimal cuda cudnn opencl"

DEPEND=">=dev-lang/lua-5.1:=
dev-lang/luajit:2
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
