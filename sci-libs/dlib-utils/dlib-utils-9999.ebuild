# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3 toolchain-funcs

DESCRIPTION="DLib is a collection of C++ classes to solve common task."
HOMEPAGE="https://github.com/dorian3d/DLib"
# Original repository is not compatible with OpenCV 3* https://github.com/dorian3d/DLib.git"
EGIT_REPO_URI="https://github.com/archenroot/DLib-1.git"


LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="-asserts +avx +blas cpponly +cuda doc examples gif jpeg +lapack mkl-fft png sqllite3 test trace X"

RDEPEND=""
#DEPEND="test? ( ${RDEPEND} )"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=()
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
