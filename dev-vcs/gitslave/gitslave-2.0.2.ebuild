# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3" #soon deprecated

inherit eutils

DESCRIPTION="Git extensions supporting an advanced branching model"
GITHUB_USER="Uroc327Mirrors"
GITHUB_TAG="${PV}"
HOMEPAGE="https://github.com/${GITHUB_USER}/${PN}"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/v${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="primaryuri"

# Could make parallel and term::prograssbar optional
DEPEND="
	dev-vcs/git
	>=dev-lang/perl-5
	dev-perl/Parallel-Iterator
"

#  dev-perl/Term-ProgressBar

RDEPEND="$DEPEND"

src_compile() {
	make prefix='/usr/bin' all #use emake (?)
}

src_install() {
	exeinto /usr/bin
	doexe gits
	doexe contrib/gitin
	doexe contrib/gits-checkup

	insinto /usr/share/man/man1
	doins gits.1
	doins contrib/gits-checkup.1
	doins contrib/gitin.1

	dodoc BugsTodo
	dodoc LICENSE.README
	dodoc LICENSE.TXT
	dodoc README
	dodoc ReleaseNotes
	dodoc gits-man-page.html
	dodoc index.html
	dodoc tutorial-basic.html
	dodoc tutorial.css
}
