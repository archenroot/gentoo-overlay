# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=XAOC
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Perl interface to the Virtual Terminal Emulation library."

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=dev-perl/gtk2-perl-1.00
	>=dev-perl/glib-perl-1.01
	x11-libs/vte:0"

DEPEND="${RDEPEND}
	>=dev-perl/extutils-pkgconfig-1.03
	>=dev-perl/ExtUtils-Depends-0.202
	virtual/pkgconfig"

SRC_TEST=do