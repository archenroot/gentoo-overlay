# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils user systemd

DESCRIPTION="The Apache Cassandra database is the right choice when you need
scalability and high availability without compromising performance."
HOMEPAGE="http://cassandra.apache.org/"
SRC_URI="mirror://apache/cassandra/${PV}/apache-cassandra-${PV}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"

DEPEND="
    >=virtual/jdk-1.5
    "
RDEPEND="${DEPEND}
    systemd? ( sys-apps/systemd )"

S="${WORKDIR}/apache-cassandra-${PV}"
INSTALL_DIR="/opt/cassandra"

pkg_setup() {
    enewgroup cassandra
    enewuser cassandra -1 /bin/bash ${INSTALL_DIR} cassandra
}

src_prepare() {
    cd "${S}"
    find . \( -name \*.bat -or -name \*.exe \) -delete
    rm bin/stop-server
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r bin conf interface lib pylib tools

    for i in bin/* ; do
        if [[ $i == *.in.sh ]]; then
            continue
        fi
        fperms 755 ${INSTALL_DIR}/${i}
        make_wrapper "$(basename ${i})" "${INSTALL_DIR}/${i}"
    done

    keepdir /var/lib/cassandra
    fowners -R cassandra:cassandra ${INSTALL_DIR}
    fowners -R cassandra:cassandra /var/lib/cassandra

    if use systemd; then
        systemd_dounit "${FILESDIR}/cassandra.service"
    else
       # newinitd "${FILESDIR}/init" cassandra
	newinitd "${WORKDIR}/apache-cassandra-${PV}/bin/cassandra" cassandra
    fi

    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/conf\"" > "${T}/25cassandra" || die
    doenvd "${T}/25cassandra"
}
