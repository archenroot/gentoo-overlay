# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit npm

DESCRIPTION="Standalone JavaScript YAML 1.2 Parser & Encoder."

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-nodejs/uglify-js-2.4.0"
RDEPEND=">=net-libs/nodejs-0.8.10
	>=dev-nodejs/argparse-0.1.4
	>=dev-nodejs/glob-3.1.11"

src_compile() {
	./build
}

src_install() {
	npm_src_install

	dobin bin/*
}
