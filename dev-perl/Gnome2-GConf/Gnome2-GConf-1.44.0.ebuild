# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TSCH
MODULE_VERSION=1.044
inherit perl-module

DESCRIPTION="Perl wrappers for the GConf configuration engine."

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="gnome-base/gconf:2
	>=dev-perl/glib-perl-1.120
	dev-lang/perl"

DEPEND="${RDEPEND}
	>=dev-perl/extutils-pkgconfig-1.03
	>=dev-perl/ExtUtils-Depends-0.202
	virtual/pkgconfig"

SRC_TEST=do