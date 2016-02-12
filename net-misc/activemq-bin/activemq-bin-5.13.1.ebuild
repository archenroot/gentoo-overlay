EAPI="5"

inherit eutils user

DESCRIPTION="Apache ActiveMQ is the most popular and powerful open source messaging and Integration Patterns server"
HOMEPAGE="http://activemq.apache.org/"
LICENSE="Apache-2.0"
SRC_URI="mirror://apache/activemq/${PV}/apache-activemq-${PV}-bin.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/apache-activemq-${PV}"
MY_PN="activemq"
INSTALL_DIR="/opt/${MY_PN}"

pkg_setup() {
    enewuser ${MY_PN} -1 /bin/bash ${INSTALL_DIR}
}

src_prepare() {
    cd "${S}"
    find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r *

    fperms 755 "${INSTALL_DIR}/bin/${MY_PN}"
    make_wrapper "${MY_PN}" "${INSTALL_DIR}/bin/${MY_PN}"

    fperms 755 "${INSTALL_DIR}/bin/${MY_PN}"
    make_wrapper "${MY_PN}" "${INSTALL_DIR}/bin/${MY_PN}"

    newinitd "${FILESDIR}/init" "${MY_PN}"

    fowners -R ${MY_PN}:${MY_PN} ${INSTALL_DIR}

    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/conf\"" > "${T}/25${MY_PN}" || die
    doenvd "${T}/25${MY_PN}"
}
