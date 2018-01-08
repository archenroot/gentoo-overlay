# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="NVIDIA Docker"
HOMEPAGE="https://github.com/NVIDIA/nvidia-docker"
SRC_URI="https://github.com/NVIDIA/nvidia-docker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="NVIDIA CORPORATION"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-emulation/docker
"
RDEPEND="${DEPEND}"

src_prepare(){
	sudo useradd -r -M -d /var/lib/nvidia-docker -s /usr/sbin/nologin nvidia-docker
	enewuser nvidia-docker
}
src_compile() {
	emake prefix="/usr"
}

src_install() {
	emake prefix="${D}/usr" install
}
