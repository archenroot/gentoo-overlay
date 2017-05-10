# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="pig"

DESCRIPTION="High-level language and platform for analyzing large data sets"
HOMEPAGE="http://hadoop.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${MY_PN}-${PV}/${MY_PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-cluster/apache-hadoop-bin"

S="${WORKDIR}/${MY_PN}-${PV}"
INSTALL_DIR="/opt/${MY_PN}-${PV}"


src_install() {
	dobin bin/pig
	dodir "${INSTALL_DIR}"
	mv "${S}"/{contrib,lib,scripts,src/packages/templates,test,*.jar} "${D}${INSTALL_DIR}"
	fowners -Rf root:hadoop "${INSTALL_DIR}"

	cat > 99pig <<-EOF
PIG_HOME="${INSTALL_DIR}"
PIG_CLASSPATH="/opt/hadoop"
EOF
	[ `egrep -c "^[0-9].*#.* sandbox" /etc/hosts` -ne 0 ] && echo "PIG_HEAPSIZE=192" >> 99pig
	doenvd 99pig
	dosym ${INSTALL_DIR} /opt/${MY_PN}
}

