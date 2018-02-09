# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN="hbase"

DESCRIPTION="HBase is the Hadoop database."
HOMEPAGE="http://hadoop.apache.org/"
SRC_URI="https://www-us.apache.org/dist/${MY_PN}/${PV}/${MY_PN}-${PV}-bin.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-cluster/apache-hadoop-bin"
# sys-cluster/apache-zookeeper
# dev-lang/ruby

S="${WORKDIR}/${MY_PN}-${PV}"
INSTALL_DIR=/opt/"${MY_PN}-${PV}"

src_install() {
	# Update hbase-env.sh
	JAVA_HOME=$(java-config -g JAVA_HOME)
	sed -i -e "2iexport JAVA_HOME=${JAVA_HOME}" conf/hbase-env.sh || die "sed failed"
	sed -i -e "3iexport HBASE_LOG_DIR=/var/log/hadoop"  conf/hbase-env.sh

	dodir "${INSTALL_DIR}"
	mv "${S}"/* "${D}${INSTALL_DIR}" || die "install failed"

	# env file
	cat > 99hbase <<-EOF
		PATH=${INSTALL_DIR}/bin
		CONFIG_PROTECT=${INSTALL_DIR}/conf
	EOF
	doenvd 99hbase

	cat > hbase <<EOF
#!/sbin/runscript
		start() {
			${INSTALL_DIR}/bin/start-hbase.sh > /dev/null
			}
		stop() {
			${INSTALL_DIR}/bin/stop-hbase.sh > /dev/null
			}
EOF
	doinitd hbase
}
