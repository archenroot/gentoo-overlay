# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils user versionator

DESCRIPTION="Maven Repository Manager"
HOMEPAGE="http://nexus.sonatype.org/"
LICENSE="GPL-3"
MY_PN="nexus-oss-bin"
MY_PV=$(replace_version_separator 3 '-')"-01"
echo "Debug: custom package version: ${MY_PV}"
MY_P="${MY_PN}-${MY_PV}"

SRC_URI="https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.14.0-01-bundle.tar.gz"
#https://github.com/sonatype/nexus-oss/archive/nexus-2.11.4-01.tar.gz"
#https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.14.0-01-bundle.tar.gz
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""
S="${WORKDIR}"
echo "Debug: working directory: ${WORKDIR}"
RDEPEND=">=virtual/jdk-1.7"
INSTALL_DIR="/opt/nexus"
WEBAPP_DIR="${INSTALL_DIR}/nexus-oss-webapp"

pkg_setup() {
#enewgroup <name> [gid]
enewgroup nexus
#enewuser <user> [uid] [shell] [homedir] [groups] [params]
enewuser nexus -1 /bin/bash ${WORKDIR}/nexus-${MY_PV} "nexus"
}

src_unpack() {
unpack ${A}
cd "${S}"
# epatch "${FILESDIR}/${P}.patch"
}

src_install() {
echo "Debug: WEBAPP_DIR: ${WEBAPP_DIR}"
echo "Debug: INSTALL_DIR: ${INSTALL_DIR}"
echo "Debug: doins nexus-${PV}-01"
echo "Debug: ${WORKDIR}/nexus-${MY_PV}/bin/nexus"
insinto ${WEBAPP_DIR}

doins -r nexus-${PV}-01/*
newinitd "${WORKDIR}/nexus-${MY_PV}/bin/nexus" nexus

fowners -R nexus:nexus ${INSTALL_DIR}
# Deprecated - last seen in in 2.5.0 version
# fperms 755 "${INSTALL_DIR}/nexus-oss-webapp/bin/jsw/linux-x86-32/nexus"
fperms 755 "${INSTALL_DIR}/nexus-oss-webapp/bin/jsw/linux-x86-32/wrapper"
fperms 755 "${INSTALL_DIR}/nexus-oss-webapp/bin/jsw/linux-x86-64/wrapper"

}
