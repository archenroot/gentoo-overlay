# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="NVIDIA container runtime library"
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"
SRC_URI="https://github.com/NVIDIA/libnvidia-container/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/NVIDIA/libnvidia-container.git"
EGIT_COMMIT="881c88e2e5bb682c9bb14e68bd165cfb64563bb1"
LICENSE="NVIDIA CORPORATION"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-emulation/docker
	net-libs/rpcsvc-proto
	sys-devel/bmake
	sys-apps/lsb-release
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}_change_default_prefix.patch"
	"${FILESDIR}/${PN}_fix-rpc-include-path.patch"
)

src_compile() {
	echo $(pwd)
	emake prefix="/usr"
}

src_install() {
	echo $(pwd)
	emake prefix="${D}/usr" install
}
