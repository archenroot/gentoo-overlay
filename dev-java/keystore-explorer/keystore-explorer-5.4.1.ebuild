# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils versionator git-r3

MY_PV=$(replace_all_version_separators '')

DESCRIPTION="Keystore management tool."
SRC_URI="https://github.com/kaikramer/keystore-explorer/archive/v${PV}.tar.gz"
HOMEPAGE="http://keystore-explorer.sourceforge.net"

EGIT_REPO_URI="https://github.com/kaikramer/keystore-explorer.git"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-java/java-config
    || ( >=dev-java/oracle-jdk-bin-1.8 >=dev-java/oracle-jre-bin-1.8 )"

S="${WORKDIR}/kse-${MY_PV}"

src_unpack() {
    unpack ${A}
    rm -v "$S/kse.exe" || die
}
src_install() {
	local dir="/opt/${PN}"
	local exe="kse"

	dobin  "${FILESDIR}/kse"

	insinto "${dir}" || die
	doins -r * || die
	fperms 755 "${dir}/kse.sh" || die

	newicon "icons/kse_128.png" "${exe}.png" || die
	make_desktop_entry "${exe}" "Keystore Explorer" "${exe}" "Development" || die
}
