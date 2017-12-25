# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Apache Mesos is an open-source project to manage computer clusters."
HOMEPAGE="https://github.com/apache/mesos"
EGIT_REPO_URI="https://github.com/apache/mesos.git"

LICENSE="UNKNOWN"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"
#S=${S}/src
src_prepare() {


	cmake-utils_src_prepare
}

src_configure() {
	
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
