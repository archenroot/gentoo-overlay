# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1 
AUTOTOOLS_AUTORECONF=1 

inherit base git-r3 autotools-utils 

DESCRIPTION="" 
HOMEPAGE="https://github.com/mariusae/trickle" 

EGIT_REPO_URI="https://github.com/mariusae/trickle.git" 
#EGIT_REPO_COMMIT="8ede0e0dd6624bbc308e21d3c26e3df80758a92c"

DESCRIPTION="A portable lightweight userspace bandwidth shaper"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

src_configure() {
	econf --with-posix-regex
}
src_compile() {
	sed -i '/#define in_addr_t/ s:^://:' config.h

	emake DESTDIR="${D}" install
#base_src_compile configure
#	emake -j1 || die "make failed"
}
