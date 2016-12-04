# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Library to deal with DWARF Debugging Information Format"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://www.prevanders.net/${PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/dwarf-${PV}"

# dirty hack, since I can't properly patch buildsystem
QA_PREBUILT="*/${PN}.so"

src_configure() {
	econf --enable-shared
}

src_install() {
	dolib.a libdwarf/libdwarf.a || die
	newlib.so libdwarf/libdwarf.so libdwarf.so.1 || die
	dosym /usr/lib/libdwarf.so.1 /usr/lib/libdwarf.so || die

	insinto /usr/include/libdwarf
	doins libdwarf/libdwarf.h || die
	doins libdwarf/dwarf.h || die

	dodoc NEWS README || die
}
