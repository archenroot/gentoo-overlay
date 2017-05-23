# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit git-r3 autotools-utils

DESCRIPTION=""
HOMEPAGE="https://github.com/facebook/fbthrift"
inherit git-r3
EGIT_REPO_URI="https://github.com/facebook/fbthrift.git"
#EGIT_COMMIT="e790a9675915df21148be308bd56eade52ca4084"
KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs"

RDEPEND="
	dev-cpp/folly
	sys-process/numactl
	dev-cpp/wangle
	app-crypt/mit-krb5
	dev-libs/cyrus-sasl
	sys-process/numactl
	dev-libs/openssl
	dev-libs/libevent
	dev-libs/boost
	dev-cpp/glog
	dev-libs/double-conversion
	app-arch/snappy"

DEPEND="${DEPEND}
	>=dev-util/cmake-3.7.1
	sys-devel/flex
	sys-devel/bison
	dev-util/scons
	virtual/pkgconfig
"

S="${WORKDIR}/${P}/thrift"

src_configure() {
	autotools-utils_src_prepare
}
