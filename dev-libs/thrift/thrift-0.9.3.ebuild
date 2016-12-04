# Copyright 2015-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-r1

DESCRIPTION="Software framework for scalable cross-language services development"
HOMEPAGE="http://thrift.apache.org"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# Thrift 0.9.3 cmake build doesn't support other generator libraries
# TODO: as3 c_glib cocoa cpp csharp d delphi erl go haxe hs java javame js lua nodejs ocaml perl php py rb st ts
IUSE="cpp c_glib python qt4 qt5 std-cxx11"

RDEPEND="
	dev-libs/boost:=
	dev-libs/openssl:=
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )

	cpp? (
		dev-libs/libevent
		sys-libs/zlib
	)

	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	sys-devel/flex
	>=sys-devel/gcc-4.8
	sys-devel/flex
	virtual/yacc
	c_glib? ( dev-libs/glib )
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with std-cxx11 STDTHREADS)
	)
	for flag in ${IUSE}; do
		mycmakeargs+=($(cmake-utils_use_with ${flag/+/}))
	done

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Thrift 0.9.3 doesn't install python libs
	install_python() {
		cd "${S}/lib/py/" || die
		${EPYTHON} "${S}/lib/py/setup.py" install --root "${D}"

		python_optimize
	}
	if use python; then
		python_foreach_impl install_python
	fi

}
