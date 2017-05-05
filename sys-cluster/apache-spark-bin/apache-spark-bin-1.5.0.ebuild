# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit user

MY_PN="spark"

DESCRIPTION="Software framework for fast cluster computing"
HOMEPAGE="http://spark.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${MY_PN}-${PV}/${MY_PN}-${PV}-bin-hadoop2.6.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scala"

DEPEND="scala? ( dev-lang/scala )"

RDEPEND="virtual/jre
scala? ( dev-lang/scala )"


S="${WORKDIR}/${MY_PN}-${PV}-bin-hadoop2.6"
INSTALL_DIR=/opt/${MY_PN}-${PV}

pkg_setup(){
	enewgroup hadoop
	enewuser spark -1 /bin/bash /home/spark hadoop
}

src_install() {
	sandbox=`egrep -c "^[0-9].*#.* sandbox" /etc/hosts`
	workmem=1024m
	[ $sandbox -ne 0 ] && workmem=192m

	# create file spark-env.sh
	cat > conf/spark-env.sh <<-EOF
SPARK_LOG_DIR=/var/log/spark
SPARK_PID_DIR=/var/run/pids
SPARK_LOCAL_DIRS=/var/lib/spark
SPARK_WORKER_MEMORY=${workmem}
SPARK_WORKER_DIR=/var/lib/spark
EOF

	dodir "${INSTALL_DIR}"
	diropts -m770 -o spark -g hadoop
	dodir /var/log/spark
	dodir /var/lib/spark
	rm -f bin/*.cmd
	# dobin bin/*
	fperms g+w conf/*
	mv "${S}"/* "${D}${INSTALL_DIR}"
	fowners -Rf root:hadoop "${INSTALL_DIR}"

	# conf symlink
	dosym ${INSTALL_DIR}/conf /etc/spark

	cat > 99spark <<EOF
SPARK_HOME="${INSTALL_DIR}"
SPARK_CONF_DIR="/etc/spark"
PATH="${INSTALL_DIR}/bin"
EOF
	doenvd 99spark

	# init scripts
	newinitd "${FILESDIR}"/"${MY_PN}.init" "${MY_PN}.init"
	dosym  /etc/init.d/"${MY_PN}.init" /etc/init.d/"${MY_PN}-worker"
	if [ `egrep -c "^[0-9].*${HOSTNAME}.*#.* sparkmaster" /etc/hosts` -eq 1 ] ; then
		dosym  /etc/init.d/"${MY_PN}.init" /etc/init.d/"${MY_PN}-master"
	fi
	dosym "${INSTALL_DIR}" "/opt/${MY_PN}"
}
