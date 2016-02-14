# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit webapp depend.php

DESCRIPTION="File sharing platform similar to dropbox"
HOMEPAGE="https://pyd.io/"
SRC_URI="http://sourceforge.net/projects/ajaxplorer/files/${PN}/stable-channel/${PV}/${PN}-core-${PV}.tar.gz/download -> ${P}.tar.gz"
RESTRICTION="mirror"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="+webdav"

DEPEND="webdav? ( dev-php/PEAR-HTTP_WebDAV_Client )"
RDEPEND="${DEPEND}"

need_php_httpd

S="${WORKDIR}/${PN}-core-${PV}"

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r ${S}/*

	find "data" -type d | while read dir ; do
		webapp_serverowned "${MY_HTDOCSDIR}/${dir}"
	done

	webapp_configfile "${MY_HTDOCSDIR}/base.conf.php"
	webapp_configfile "${MY_HTDOCSDIR}/conf/bootstrap_"{conf,context,repositories}".php"
	webapp_configfile "${MY_HTDOCSDIR}/conf/mime.types"
	webapp_configfile "${MY_HTDOCSDIR}/conf/extensions.conf.php"

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
}
