# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit user

MY_PN="hive"

DESCRIPTION="High-level language and platform for analyzing large data sets"
HOMEPAGE="http://hadoop.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${MY_PN}-${PV}/apache-${MY_PN}-${PV}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/mysql
dev-java/jdbc-mysql"
RDEPEND="$DEPEND
sys-cluster/apache-hadoop-bin"

S="${WORKDIR}/apache-${MY_PN}-${PV}-bin"
INSTALL_DIR="/opt/${MY_PN}-${PV}"

pkg_setup(){
	enewgroup hadoop
	enewuser hive -1 /bin/bash /home/hive hadoop
}

src_install() {
	HIVEPASS="hive123"
	IP=`grep $HOSTNAME /etc/hosts | awk '{print $1 }' `

	# create hive-site.xml
	cat > conf/hive-site.xml <<EOF
<configuration>
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:mysql://localhost/metastore</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>com.mysql.jdbc.Driver</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionUserName</name>
  <value>hive</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionPassword</name>
  <value>${HIVEPASS}</value>
</property>
<property>
  <name>datanucleus.transactionIsolation</name>
  <value>repeatable-read</value>
</property>
<property>
  <name>datanucleus.valuegeneration.transactionIsolation</name>
  <value>repeatable-read</value>
</property>
</configuration>
EOF

	# create matastore in MySQL
	sudo mysql -u root <<EOF
CREATE DATABASE metastore;
USE metastore;
SOURCE ${S}/scripts/metastore/upgrade/mysql/hive-schema-0.10.0.mysql.sql;
CREATE USER 'hive'@'localhost' IDENTIFIED BY '${HIVEPASS}';
GRANT ALL ON metastore.* TO 'hive'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
	[ $? -eq 0 ] || die "unable to create Hive metastore in MySQL"

	#install
	insinto "${INSTALL_DIR}"
	mv "${S}"/* "${D}${INSTALL_DIR}"
	chown -Rf root:hadoop "${D}${INSTALL_DIR}"

	cat > 99hive <<EOF
HIVE_HOME="${INSTALL_DIR}"
HCAT_HOME="${INSTALL_DIR}/hcatalog"
HIVE_CONF_DIR="${INSTALL_DIR}/conf"
PATH="${INSTALL_DIR}/bin"
EOF
	doenvd 99hive
	# Hive needs JDBS libs
	dosym /usr/share/jdbc-mysql/lib/jdbc-mysql.jar ${INSTALL_DIR}/lib/jdbc-mysql.jar
	dosym ${INSTALL_DIR} /opt/${MY_PN}
}
