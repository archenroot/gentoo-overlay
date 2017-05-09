# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="A portable lightweight userspace bandwidth shaper"
HOMEPAGE="http://monkey.org/~marius/pages/?page=trickle"
SRC_URI="ftp://ftp.debian.org/debian/pool/main/t/trickle/trickle_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

src_compile() {
	base_src_compile configure
	sed -i '/#define in_addr_t/ s:^://:' config.h
	emake -j1 || die "make failed"
}
