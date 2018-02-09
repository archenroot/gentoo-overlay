# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6)

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
        SCM="git-r3"
        EGIT_REPO_URI="https://github.com/BVLC/caffe.git"
fi

inherit ${SCM} cmake-utils python-single-r1

# Can't use cuda.eclass as nvcc does not like --compiler-bindir set there for some reason

DESCRIPTION="Deep learning framework by the BVLC"
HOMEPAGE="http://caffe.berkeleyvision.org/"
if [ "${PV#9999}" != "${PV}" ] ; then
        SRC_URI=""
        KEYWORDS=""
else
        SRC_URI="https://github.com/BVLC/caffe/archive/${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64 ~arm"
fi


LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="cuda leveldb lmdb opencv python"

CDEPEND="
	dev-libs/boost:=[python?]
	media-libs/opencv:=
	python? (
    dev-python/protobuf-python:=
  )
	dev-cpp/glog:=
	dev-cpp/gflags:=
	sci-libs/atlas:=[lapack]
	dev-libs/leveldb:=
	app-arch/snappy:=
	dev-db/lmdb:=
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
	python? (
		${PYTHON_DEPS}
	)
"
DEPEND="
	${CDEPEND}
	sys-devel/bc
"
RDEPEND="
	${CDEPEND}
	python? (
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		media-gfx/pydot[${PYTHON_USEDEP}]
		sci-libs/scikits_image[${PYTHON_USEDEP}]
	)
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCPU_ONLY=1
		-DCPU_ONLY="$(usex !cuda)"
		-DUSE_OPENCV="$(usex opencv)"
		-DUSE_LEVELDB="$(usex leveldb)"
		-DUSE_LMDB="$(usex lmdb)"
    -DHDF5_INCLUDE_DIR="/usr/include"
		)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	#use doc && cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install
}
