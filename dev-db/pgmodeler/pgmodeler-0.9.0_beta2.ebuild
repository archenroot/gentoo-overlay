# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils multilib

DESCRIPTION="Design, diagram, and deploy PostgreSQL databases"
HOMEPAGE="http://www.pgmodeler.com.br/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV/_/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test +plugins"

RDEPEND="
	>=dev-db/postgresql-9.4.5-r1:=
	dev-libs/libxml2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	plugins? ( >=dev-qt/designer-5.4.2:5 )
	"
DOCS=( CHANGELOG.md README.md )

S="${WORKDIR}/${PN}-${PV/_/-}"

src_prepare() {

	# Rename main file.
	sed -i -e 's/TARGET = pgmodeler/TARGET = pgmodeler-bin/' main/main.pro \
		|| die 'failed to rename binary'

	# Enable the plugins building
	if use plugins; then
		sed -i '20a SUBDIRS += plugins' pgmodeler.pro \
		&& sed -i 's/SUBDIRS\ +=\ tests\ plugins/SUBDIRS += tests/g' pgmodeler.pro \
			|| die 'failed to change pgmodeler.pro'
	fi
}

src_configure() {
	local prefix="${D}usr"
	local bindir="${prefix}/bin"
	local libdir="${prefix}/$(get_libdir)/${PN}"
	local sharedir="${prefix}/share/${PN}"
	local pluginsdir="${sharedir}/plugins"
	mkdir -p "${bindir}" "${libdir}" "${sharedir}" "${pluginsdir}" || die
	local pc="/usr/$(get_libdir)/postgresql/pkgconfig/"

	# The PKG_CONFIG_PATH thing is probably a bug in
	# dev-db/postgresql-base. See bug #512236.
	PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${pc}" eqmake5 "${PN}.pro" \
	PREFIX="${prefix}" \
	PRIVATEBINDIR+="${bindir}" \
	PRIVATELIBDIR+="${libdir}" \
	SHAREDIR+="${sharedir}" \
	PLUGINSDIR+="${pluginsdir}"
}

src_compile() {
	local pc="/usr/$(get_libdir)/postgresql/pkgconfig/"
	PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${pc}" emake
}

src_install() {
	local libdir="/usr/$(get_libdir)/${PN}"

	default

	# Install our shell script wrapper.
	cat <<-EOF > "${S}/${PN}"
	#!/bin/bash

	# Use this script if you having problems running pgModeler.
	# The most common execution problem is the missing library error:
	# [ ./pgmodeler: error while loading shared libraries: libutils.so.1: cannot open shared object file: No such file or directory ]

	# This script configures all the needed enviroment variables but does not affects the configuration of the whole system.
	# The only downside of this script is that you can not call the "pgmodeler" executable directly, being obligated
	# to use this script every time you want to run the application.

	# For a more elaborated solution you may find useful the usage of pgmodeler.vars file.
	# Details about the use of that file are in it's comments.

	export PGMODELER_ROOT="${ROOT}usr/share/pgmodeler"

	# There is no good way to install pgmodeler globally for more than one
	# user, since it requires write access to its own conf files. As a
	# workaround, we install the upstream conf files globally, and copy them
	# to the user's home directory before launching pgmodeler.
	USERDIR="\${HOME}/.pgmodeler"
	if [ ! -d "\${USERDIR}/conf" ]; then
		mkdir -p "\${USERDIR}"
		cp --no-clobber -a "\${PGMODELER_ROOT}/conf" "\${USERDIR}/"
	fi

	export PGMODELER_TMPL_CONF_DIR="\${USERDIR}/conf"
	export PGMODELER_SCHEMAS_DIR="\${PGMODELER_ROOT}/schemas"
	export PGMODELER_LANG_DIR="\${PGMODELER_ROOT}/lang"
	export PGMODELER_PLUGINS_DIR="\${PGMODELER_ROOT}/plugins"
	export PGMODELER_SAMPLES_DIR="\$PGMODELER_ROOT/samples"
	export PGMODELER_CHANDLER_PATH="${ROOT}usr/bin/pgmodeler-ch"
	export PGMODELER_CLI_PATH="${ROOT}usr/bin/pgmodeler-cli"
	export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:"${libdir}"

	"/usr/bin/${PN}-bin" "\$@" &
	EOF

	dobin "${S}/${PN}"

	insinto "/usr/share/${PN}"
	doins -r "${S}/conf"
	doins -r "${S}/schemas"
	doins -r "${S}/samples"

	# Icons
	doicon "${S}/conf/pgmodeler_logo.png"
	make_desktop_entry ${PN} PgModeler "${PN}_logo.png"
}

src_test() {
	einfo ">>> Test phase: ${CATEGORY}/${PF}"
	local pc="/usr/$(get_libdir)/postgresql/pkgconfig/"
	cd "${S}/tests" || die
	PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${pc}" eqmake5 tests.pro
	emake
	# Before `make install`, all of the binaries and libraries are
	# stored in ${S}/build.
	PGMODELER_ROOT="${S}/build" ../build/tests || die "tests failed"
}
