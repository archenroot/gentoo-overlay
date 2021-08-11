# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils git-r3

DESCRIPTION="Real-time multi-person keypoint detection library for body, face and hands estimation."
HOMEPAGE="https://github.com/CMU-Perceptual-Computing-Lab/openpose"
EGIT_REPO_URI="https://github.com/CMU-Perceptual-Computing-Lab/openpose.git"
EGIT_REPO_COMMIT="3e957ba6a10884496583ff5c351622049fbd65a0"

LICENSE="CMU-openpose
	caffe? ( BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="caffe cuda cudnn"

RDEPEND=""
DEPEND="${RDEPEND}"
S="${S}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCPU_ONLY="ON"
		-DUSE_CAFFE="$(usex caffe)"
		-DUSE_CUDA="$(usex cuda)"
		-DCMAKE_BUILD_TYPE="release"
	)
	elog "CMake args: $mycmakeargs"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
