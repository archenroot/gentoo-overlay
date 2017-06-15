# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3
DESCRIPTION="Sparse Parallel Robust Algorithms Library"
HOMEPAGE="https://github.com/ralna/spral"
EGIT_REPO_URI="https://github.com/ralna/spral.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/metis"

src_prepare() {
	default
	WANT_AUTOCONF=2.5 eautoreconf
	WANT_AUTOMAKE=1.9 eautomake
}

src_configure() {
	local myeconfargs=(
		BLAS_LIBS=$(pkg-config --libs-only-l blas)
		LAPACK_LIBS=$(pkg-config --libs-only-l lapack)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake
}