# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils toolchain-funcs

DESCRIPTION="Numerical and networking C++ library"
HOMEPAGE="http://dlib.net/"
SRC_URI="https://github.com/davisking/dlib/archive/v19.4.tar.gz"
#EGIT_REPO_URL="https://github.com/davisking/dlib.git"
#EGIT_COMMIT="581332bac13b3d3d02a8096671cc2f7b1379928a"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-asserts +avx +blas cpponly +cuda doc examples gif jpeg +lapack mkl-fft png sqllite3 test trace X"

RDEPEND="
	blas? ( virtual/blas )
	jpeg? ( virtual/jpeg:0= )
	lapack? ( virtual/lapack )
	png? ( media-libs/libpng:0= )
	X? ( x11-libs/libX11 )"
DEPEND="test? ( ${RDEPEND} )"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
			-DUSE_AVX_INSTRUCTIONS=1
			-DWITH_DLIB_ISO_CPP_ONLY_STR="$(usex cpponly)"
			-DWITH_DLIB_NO_GUI_SUPPORT_STR="$(usex X)"
			-DWITH_DLIB_ENABLE_STACK_TRACE_STR="$(usex trace)"
			-DWITH_DLIB_USE_BLAS_STR="$(usex blas)"
			-DWITH_DLIB_USE_LAPACK_STR="$(usex lapack)"
			-DWITH_DLIB_USE_CUDA_STR="$(usex cuda)"
			-DWITH_DLIB_PNG_SUPPORT_STR="$(usex png)"
			-DWITH_DLIB_GIF_SUPPORT_STR="$(usex gif)"
			-DWITH_DLIB_JPEG_SUPPORT_STR="$(usex jpeg)"
			-DWITH_DLIB_LINK_WITH_SQLITE3_STR="$(usex sqllite3)"
			-DWITH_DLIB_USE_MKL_FFT_STR="$(usex mkl-fft)"
			-DWITH_DLIB_ENABLE_ASSERTS_STR="$(usex asserts)"
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
