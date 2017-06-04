# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Enhanced hierarchical bag-of-word library for C++"
HOMEPAGE="https://github.com/dorian3d/DBoW2"
EGIT_REPO_URI="https://github.com/dorian3d/DBoW2.git"

LICENSE="DBoW2-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

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
