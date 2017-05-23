# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils user

DESCRIPTION="Oracle GlassFish Server is the world's first implementation of the Java Platform, Enterprise Edition (Java EE) 6 specification.  Built using the GlassFish Server Open Source Edition, Oracle GlassFish Server delivers a flexible, lightweight, and production-ready Java EE 6 application server."
HOMEPAGE="http://www.oracle.com/technetwork/middleware/glassfish/overview/index.html"
LICENSE="ogsla"
#SRC_URI="http://download.oracle.com/otn-pub/java/glassfish/3122/ogs-${PV}.zip"
SRC_URI=http://dlc.sun.com.edgesuite.net/glassfish/${PV}/release/glassfish-${PV}.zip
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.7"

S="${WORKDIR}/glassfish4"
MY_PN="oracle-glassfish"
INSTALL_DIR="/opt/${MY_PN}"

pkg_setup() {
	enewgroup oracle-glassfish
	enewuser oracle-glassfish -1 /bin/bash ${INSTALL_DIR}/home oracle-glassfish
}

src_prepare() {
	find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_install() {
	insinto ${INSTALL_DIR}

	doins -r glassfish javadb mq pkg bin
	keepdir ${INSTALL_DIR}/home

	for i in bin/* ; do
		fperms 755 ${INSTALL_DIR}/${i}
		make_wrapper "$(basename ${i})-oracle" "${INSTALL_DIR}/${i}"
	done

	for i in glassfish/bin/* ; do
		fperms 755 ${INSTALL_DIR}/${i}
	done
		# TODO - major version function
	newinitd "${WORKDIR}/glassfish4/bin/asadmin" oracle-glassfish

	keepdir ${INSTALL_DIR}/glassfish/domains
	fperms -R g+w "${INSTALL_DIR}/glassfish/domains"

	fowners -R oracle-glassfish:oracle-glassfish ${INSTALL_DIR}

	echo "CONFIG_PROTECT=\"${INSTALL_DIR}/glassfish/config\"" > "${T}/25oracle-glassfish"
	doenvd "${T}/25oracle-glassfish"
}

pkg_postinst() {
	elog "You must be in the oracle-glassfish group to use GlassFish without root rights."
	elog "You should create separate domain for development needs using"
	elog "    \$ asadmin create-domain devdomain"
	elog "under your account"
	elog "Don't use same domain under different credentials!"
}
