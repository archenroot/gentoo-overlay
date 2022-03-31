# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
 
EAPI=7
 
inherit git-r3

DESCRIPTION="tool to monitor network traffic based on processes"
HOMEPAGE="https://github.com/berghetti/netproc"
EGIT_REPO_URI="https://github.com/berghetti/netproc.git"
#EGIT_COMMIT="1bc1292bea2d51c029c7b352b1149482d74aca71"
EGIT_COMMIT="93013f16dee69c95651242dad6e949a5a375d358"
EGIT_BRANCH="dev"
 
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
 
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
