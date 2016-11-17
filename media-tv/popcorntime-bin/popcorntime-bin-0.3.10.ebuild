# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils fdo-mime multilib

DESCRIPTION="Watch Movies and TV Shows instantly"
HOMEPAGE="https://popcorntime.sh/"
SRC_URI="amd64? ( https://get.popcorntime.sh/build/Popcorn-Time-0.3.10-Linux-64.tar.xz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="splitdebug strip"

DEPEND=""
RDEPEND="dev-libs/nss
	gnome-base/gconf
	media-fonts/corefonts
	media-libs/alsa-lib
	x11-libs/gtk+:2"

S="${WORKDIR}"

src_install() {
	exeinto /opt/${PN}
	doexe Popcorn-Time

	insinto /opt/${PN}
	doins -r src node_modules icudtl.dat locales LICENSE.txt lib nw_100_percent.pak nw_200_percent.pak package.json resources.pak snapshot_blob.bin pnacl CHANGELOG.md chromedriver credits.html minidump_stackwalk nacl_helper nacl_helper_bootstrap nacl_irt_x86_64.nexe natives_blob.bin nwjc payload README.md 
    
    dosym /$(get_libdir)/libudev.so.1 /opt/${PN}/libudev.so.0
	dosym /opt/${PN}/Popcorn-Time /usr/bin/${PN}
	make_wrapper ${PN} ./Popcorn-Time /opt/${PN} /opt/bin

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop

	insinto /usr/share/pixmaps
	doins "${FILESDIR}"/${PN}.png
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	elog "${PN} ${PV} installed successfully in your system"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
