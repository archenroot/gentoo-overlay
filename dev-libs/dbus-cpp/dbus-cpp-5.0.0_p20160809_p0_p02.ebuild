# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils 
#ubuntu-versionator

UURL="https://ftp.fau.de/ubuntu/pool/main/d/dbus-cpp"
UVER_PREFIX="+16.10.${PVR_MICRO}"

DESCRIPTION="Dbus-binding leveraging C++-11"
HOMEPAGE="http://launchpad.net/dbus-cpp"
#SRC_URI="${UURL}/${MY_P}.orig.tar.gz"
SRC_URI="https://ftp.fau.de/ubuntu/pool/main/d/dbus-cpp/dbus-cpp_5.0.0+16.10.20160809.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

DEPEND="dev-cpp/gtest
	dev-libs/boost:=
	dev-libs/process-cpp
	sys-apps/dbus"

MAKEOPTS="${MAKEOPTS} -j1"

elog "Source: ${S}"
S=`echo "${S}" |sed 's,/*[^/]\+/*$,,'`
elog "Source: ${S}"

src_prepare() {
	#ubuntu-versionator_src_prepare
	use doc || \
		sed -i 's:add_subdirectory(doc)::g' \
			-i CMakeLists.txt

	use examples || \
		sed -i 's:add_subdirectory(examples)::g' \
			-i CMakeLists.txt

	use test || \
		sed -i 's:add_subdirectory(test)::g' \
			-i CMakeLists.txt
	S=${S}/src
	# Fix build errors using >=gcc-5.4.0 #
	#epatch -p1 "${FILESDIR}/dbus-cpp_fix-missing-random-include_LP1592814.diff"

	# Disable '-Werror' #
	sed -e 's/-Werror//g' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}
