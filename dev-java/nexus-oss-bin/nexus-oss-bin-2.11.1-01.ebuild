inherit eutils
DESCRIPTION="Maven Repository Manager"
HOMEPAGE="http://nexus.sonatype.org/"
LICENSE="GPL-3"
SRC_URI="http://www.sonatype.org/downloads/nexus-${PV}-01-bundle.zip"
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""
S="${WORKDIR}"
RDEPEND=">=virtual/jdk-1.7"
INSTALL_DIR="/opt/nexus"
WEBAPP_DIR="${INSTALL_DIR}/nexus-oss-webapp"
pkg_setup() {
#enewgroup <name> [gid]
enewgroup nexus
#enewuser <user> [uid] [shell] [homedir] [groups] [params]
enewuser nexus -1 /bin/bash /opt/nexus "nexus"
}
src_unpack() {
unpack ${A}
cd "${S}"
# epatch "${FILESDIR}/${P}.patch"
}
src_install() {
insinto ${WEBAPP_DIR}
doins -r nexus-${PV}-04/*
newinitd "${FILESDIR}/init.sh" nexus
fowners -R nexus:nexus ${INSTALL_DIR}
fperms 755 "${INSTALL_DIR}/nexus-oss-webapp/bin/jsw/linux-x86-32/nexus"
fperms 755 "${INSTALL_DIR}/nexus-oss-webapp/bin/jsw/linux-x86-32/wrapper"
}