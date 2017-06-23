# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib
DESCRIPTION="PAC is a Perl/GTK replacement for SecureCRT/Putty/etc"
HOMEPAGE="http://sites.google.com/site/davidtv"
SRC_URI="mirror://sourceforge/${PN}/pac-4.0/pac-${PV}-all.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="freerdp mosh +rdesktop webdav vnc"

RDEPEND="freerdp? ( net-misc/freerdp )
	mosh? ( net-misc/mosh )
	rdesktop? ( net-misc/rdesktop )
	webdav? ( net-misc/cadaver )
	vnc? ( net-misc/tigervnc )
	dev-libs/ossp-uuid[perl]
	dev-perl/Crypt-CBC
	dev-perl/Gtk2
	dev-perl/Socket6
	dev-perl/net-ARP
	dev-perl/Crypt-Rijndael
	dev-perl/Crypt-Blowfish
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Gtk2-Unique
	dev-perl/gnome2-perl
	dev-perl/Gnome2-GConf
	dev-perl/gtk2-gladexml
	dev-perl/Gnome2-Vte
	dev-perl/Expect
	dev-perl/IO-Stty
	dev-perl/YAML
	dev-perl/Gtk2-AppIndicator"

S="${WORKDIR}/pac"

src_prepare() {
	rm -rf lib/ex/vte*
	find utils lib pac -type f | while read f
	do
		sed -i -e "s@\$RealBin[^']*\('\?\)\([./]*\)/lib@\1/usr/$(get_libdir)/pacmanager@g" "$f"
		sed -i -e "s@\$RealBin[^']*\('\?\)\([./]*\)/res@\1/usr/share/pacmanager@g" "$f"
	done
}

src_install() {
	dobin pac
	dodoc README

	doman res/pac.1
	insinto /usr/share/applications
	doins res/pac.desktop
	rm res/{pac.1,pac.desktop}

	insinto /usr/share/pixmaps
	newins res/pac64x64.png pac.png

	insinto /usr/$(get_libdir)/${PN}
	doins -r lib/*
	insinto /usr/share/${PN}
	doins -r res/*
	doins -r utils
	doins qrcode_pacmanager.png
}

pkg_postinst()
{
	einfo "Please install keepassx if you need a password manager."
}
