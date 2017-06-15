# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7 python3_5)
inherit distutils-r1

DESCRIPTION="EasyDict allows to access dict values as attributes (works recursively)."
HOMEPAGE="https://github.com/makinacorpus/easydict"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND=""
