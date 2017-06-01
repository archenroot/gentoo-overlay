# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Numerical and networking C++ library"
HOMEPAGE="http://dlib.net/"
GIT_REPO_URL="https://github.com/davisking/dlib.git"
EGIT_COMMIT="581332bac13b3d3d02a8096671cc2f7b1379928a"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="avx blas cpponly doc examples jpeg lapack png test X"

RDEPEND="
	blas? ( virtual/blas )
	jpeg? ( virtual/jpeg:0= )
	lapack? ( virtual/lapack )
	png? ( media-libs/libpng:0= )
	X? ( x11-libs/libX11 )"
DEPEND="test? ( ${RDEPEND} )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-17.48-makefile-test.patch
}

src_configure() {
        local mycmakeargs=(
		$(cmake-utils_use_with cpponly DLIB_ISO_CPP_ONLY_STR)
                $(cmake-utils_use_with openconnect)
		$
        )

        cmake-utils_src_configure
}
src_test() {
	cd dlib/test || die
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}"
	./test --runall || die
}

src_install() {
	dodoc dlib/README.txt
	rm -r dlib/{README,LICENSE}.txt dlib/test || die
	doheader -r dlib
	use doc && dohtml -r docs/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
