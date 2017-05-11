# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

MY_P="mesos"
MY_PN=${MY_P}-${PV}
DESCRIPTION="A cluster manager that provides efficient resource isolation and sharing across distributed applications"
HOMEPAGE="http://mesos.apache.org/"
#SRC_URI="http://archive.apache.org/dist/${PN}/${PV}/${P}.tar.gz"
SRC_URI="mirror://apache/${MY_P}/${MY_PN}/${MY_PN}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE="network-isolator perftools install-module-dependencies"
SLOT="0"

RDEPEND=">=dev-libs/apr-1.5.2
        >=net-misc/curl-7.43.0
        network-isolator? ( dev-libs/libnl )
        dev-libs/cyrus-sasl
        >=dev-vcs/subversion-1.9.4"
DEPEND=$RDEPEND

S=${WORKDIR}/${MY_PN}

src_prepare() {
	echo `pwd`
        epatch "${FILESDIR}/mesos-stout-cloexec.patch"
        epatch "${FILESDIR}/mesos-linux-ns-nosetns.patch"
        eautoreconf
}

src_configure() {
        # See https://issues.apache.org/jira/browse/MESOS-7286
        MESOS_LIB_PREFIX="${EPREFIX}/usr"
        export SASL_PATH="${MESOS_LIB_PREFIX}/lib/sasl2"
        export LD_LIBRARY_PATH="${MESOS_LIB_PREFIX}/lib:$LD_LIBRARY_PATH"
        econf --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu \
                $(use_enable perftools) \
                $(use_enable install-module-dependencies) \
                $(use_with network-isolator) \
                $(use_with network-isolator nl "${MESOS_LIB_PREFIX}") \
                --disable-python \
                --disable-java \
                --enable-optimize \
                --disable-dependency-tracking \
                --with-apr=${MESOS_LIB_PREFIX} \
                --with-curl=${MESOS_LIB_PREFIX} \
                --with-sasl=${MESOS_LIB_PREFIX} \
                --with-svn=${MESOS_LIB_PREFIX}
}

src_compile() {
        emake
}

src_test() {
        emake check
}

src_install() {
        emake DESTDIR="${D}" install
}
