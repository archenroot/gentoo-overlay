# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user

MY_PN="solr"
DESCRIPTION="Popular, blazing fast open source enterprise search platform from the Apache Lucene project"
HOMEPAGE="http://lucene.apache.org/solr/"
SRC_URI="http://www.apache.org/dist/lucene/${MY_PN}/${PV}/${MY_PN}-${PV}.tgz"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-process/lsof"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
INSTALL_DIR="/opt/${MY_PN}"


pkg_setup(){
	enewgroup hadoop
	enewuser solr -1 /bin/bash /home/solr hadoop
#	chgrp hadoop /home/solr
}


src_install() {
	sandbox=`egrep -c "^[0-9].*#.* sandbox" /etc/hosts`

	insinto "${INSTALL_DIR}"
	diropts -m770 -o root -g hadoop
	dodir /var/log/"${MY_PN}"

	#  update solr.in.sh
	echo "SOLR_PID_DIR=/var/run/local" >> bin/solr.in.sh
	echo "SOLR_LOGS_DIR=/var/log/${MY_PN}" >> bin/solr.in.sh
	[ $sandbox -ne 0 ] && echo "SOLR_HEAP=200m" >> bin/solr.in.sh


	mv "${S}"/* "${D}${INSTALL_DIR}"
	chown -Rf root:hadoop "${D}${INSTALL_DIR}"

	newinitd "${FILESDIR}/solr" solr

}
