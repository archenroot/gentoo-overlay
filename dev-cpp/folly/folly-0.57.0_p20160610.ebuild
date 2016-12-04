# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
inherit git-r3
EGIT_REPO_URI="https://github.com/facebook/folly.git"
EGIT_COMMIT="0806af8f1b68c3f5c75f6330218f49365f53d695"
KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND="dev-libs/double-conversion
		dev-libs/libevent
		dev-libs/openssl:*
		dev-cpp/gflags
		dev-cpp/glog
		>=dev-libs/boost-1.51.0[context,threads]
		<dev-libs/boost-1.61.0[context,threads]
		app-arch/lz4
		app-arch/snappy
		sys-libs/zlib
		app-arch/xz-utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/${PN}"
