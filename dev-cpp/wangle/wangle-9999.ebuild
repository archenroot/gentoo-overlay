# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="a full featured, high performance C++ futures implementation"
HOMEPAGE="https://github.com/facebook/wangle"
#SRC_URI="https://github.com/facebook/wangle/archive/v2016.11.28.00.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/facebook/wangle.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-cpp/folly"
DEPEND="${RDEPEND}
		test? ( dev-cpp/gmock )"

S="${WORKDIR}/${P}/${PN}"

src_configure() {
	#local mycmakeargs=(
	#	$(cmake-utils_use_build test TESTS)
	#)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
