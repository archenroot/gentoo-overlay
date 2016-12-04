# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="mstch is a complete implementation of {{mustache}} templates using modern C++"
HOMEPAGE="https://github.com/no1msd/mstch"
SRC_URI="https://github.com/no1msd/mstch/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

CMAKE_MIN_VERSION="3.0.0"

DEPEND="
	>=dev-libs/boost-1.54
	>=sys-devel/gcc-4.7
"
RDEPEND="${DEPEND}"
