# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit python-single-r1

DESCRIPTION="Google Cloud SDK"
HOMEPAGE="https://cloud.google.com/sdk/"
SRC_URI="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${P}-linux-x86_64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/google-cloud-sdk"

src_prepare() {
	default
	python_fix_shebang --force .
}

src_install() {
	dodir /usr/share/google-cloud-sdk
	cp -R "${S}/" "${D}/usr/share/" || die "Install failed!"
	dosym "../share/google-cloud-sdk/bin/gcloud" /usr/bin/gcloud
	dosym "../share/google-cloud-sdk/bin/gsutil" /usr/bin/gsutil
	#python_optimize "${D}/usr/share/${PN}"
}
