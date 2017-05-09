# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit user

MY_PN="cassandra"

DESCRIPTION="The Apache Cassandra database is the right choice when you need
scalability and high availability without compromising performance."
HOMEPAGE="http://cassandra.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${PV}/apache-${MY_PN}-${PV}-bin.tar.gz"
SRC_URI="http://apache.cu.be/cassandra/3.0.13/apache-cassandra-3.0.13-bin.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/jre"
RDEPEND="$DEPEND"


S="${WORKDIR}/apache-${MY_PN}-${PV}"
INSTALL_DIR="/opt/${MY_PN}-${PV}"

pkg_setup() {
	enewgroup hadoop
	enewuser cassandra -1 /bin/bash /home/cassandra hadoop
}


src_install() {
	# get the topology from /etc/hosts
	hostname=`uname -n`
	seeds=`egrep "^[0-9].*#.* cassandraseed" /etc/hosts | awk '{print $1}' `
	[[ -n $seeds ]] && seeds=`echo ${seeds} | sed 's/ /,/g' `
	sandbox=`egrep -c "^[0-9].*#.* sandbox" /etc/hosts`

	# cleanup non Unix files
	find . \( -name \*.bat -or -name \*.exe -or -name \*.dll -or -name \*.ps1 \) -delete
	rm -f bin/stop-server
	rm -f lib/sigar-bin/*solaris* lib/sigar-bin/*ppc* lib/sigar-bin/*s390* lib/sigar-bin/*ia64* ib/sigar-bin/*freebsd*

	# update JVM mem for sandbox
	if [ $sandbox -ne 0 ] ; then
		sed -e "1iexport MAX_HEAP_SIZE=256M" \
			-e "2iexport HEAP_NEWSIZE=256M" -i conf/cassandra-env.sh || die
	fi
	# update yaml for cluster case
	sed -e "s|listen_address: localhost|# listen_address: not used|" \
		-e "s|# listen_interface: .*|listen_interface: eth0|" -i conf/cassandra.yaml || die
	if [[ -n $seeds ]] ; then
		sed -e  "s|seeds: .*|seeds: \"${seeds}\"|" -i conf/cassandra.yaml
	fi
	# update storage dir
	sed -e "s|cassandra_storagedir=\"\$CASSANDRA_HOME/data\"|cassandra_storagedir=\"/var/lib/cassandra/\"|g" \
		-i bin/cassandra.in.sh || die
	# update log dir
	sed -e "s|cassandra.logdir=\$CASSANDRA_HOME\/logs|cassandra.logdir=\/var\/log\/cassandra|g" \
		-i bin/cassandra || die
	# update pyspark
	sed -e "s|python |python2 |g" -i bin/cqlsh || die

	#install
	insinto ${INSTALL_DIR}
	doins -r conf interface lib pylib tools
	mv "${S}"/bin "${D}${INSTALL_DIR}/bin"
	fowners -R cassandra:hadoop ${INSTALL_DIR}
	diropts -m770 -o root -g hadoop
	dodir /var/log/cassandra
	dodir /var/lib/cassandra

	cat > 99cassandra <<EOF
PATH="${INSTALL_DIR}/bin"
EOF
	doenvd 99cassandra
	newinitd ${FILESDIR}/cassandra cassandra

	dosym ${INSTALL_DIR} /opt/${MY_PN}
}
