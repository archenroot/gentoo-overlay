# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="Cisco AnyConnect VPN Client"
HOMEPAGE="http://www.cisco.com"
LICENSE="cisco"
SLOT="0"
KEYWORDS="~amd64"
IUSE="unpacked"

UNPACKED_NAME="anyconnect-Linux_64-${PV}.tar.gz"

SRC_URI="
	unpacked? ( ${UNPACKED_NAME} )
	!unpacked? ( vpnsetup.sh )
"
RESTRICT="fetch strip"

RDEPEND="
	x11-libs/pangox-compat
"

INSTPREFIX="/opt/cisco/vpn"
BINDIR=${INSTPREFIX}/bin
PROFILEDIR=${INSTPREFIX}/profile
SCRIPTDIR=${INSTPREFIX}/script

S="${WORKDIR}/ciscovpn"

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
}

src_unpack() {
	if use unpacked; then
		unpack ${A}
	else
		TARFILE=${T}/${UNPACKED_NAME}

		MARKER=$((`grep -an "[B]EGIN\ ARCHIVE" ${DISTDIR}/${A} | cut -d ":" -f 1` + 1))
		tail -n +${MARKER} "${DISTDIR}/${A}" > "${TARFILE}" || die "tail failed"

		tar -xzf "${TARFILE}" -C "${WORKDIR}" || die "tar failed"
	fi
}

src_install() {
	# Make sure destination directories exist
	dodir "${BINDIR}"
	exeinto "${BINDIR}"
	dodir "${PROFILEDIR}"
	dodir "${SCRIPTDIR}"

	insinto "${INSTPREFIX}"
	insopts -m444

	# Copy files to their home
	#doexe "${S}/vpn_uninstall.sh"

	doexe "${S}/vpnagentd"
	fperms 4755 "${BINDIR}/vpnagentd"

	if [ -f "${S}/vpnui" ]; then
		doexe "${S}/vpnui"
		dosym "${BINDIR}/vpnui" /usr/bin/
	else
		ewarn "vpnui does not exist. It will not be installed."
	fi

	doexe "${S}/vpn"

	if [ -d "${S}/pixmaps" ]; then
		cp -R "${S}/pixmaps" "${D}/${INSTPREFIX}" || die "can't copy pixmaps"
	else
		ewarn "pixmaps not found... Continuing with the install."
	fi

	if [ -f "${S}/anyconnect.desktop" ]; then
		domenu "${S}/anyconnect.desktop"
	else
		ewarn "anyconnect.desktop does not exist. It will not be installed."
	fi

	if [ -f "${S}/VPNManifestClient.xml" ]; then
		doins "${S}/VPNManifestClient.xml"
	else
		ewarn "VPNManifestClient.xml does not exist. It will not be installed."
	fi

	if [ -f "${S}/manifesttool" ]; then
		doexe "${S}/manifesttool"
	else
		ewarn "manifesttool does not exist. It will not be installed."
	fi

	if [ -f "${S}/update.txt" ]; then
		doins "${S}/update.txt"
	else
		ewarn "update.txt does not exist. It will not be installed."
	fi

	if [ -f "${S}/vpndownloader" ]; then
		doexe "${S}/vpndownloader"

		# create a fake vpndonloader.sh that just launches the cached downloader
		# instead of self extracting the downloader like the one on the headend.
		# This method is used because of backwards compatibilty with anyconnect
		# versions before this change since they will try to invoke vpndownloader.sh
		# during weblaunch.
		echo "ERRVAL=0" > "${D}${BINDIR}/vpndownloader.sh"
		echo ${BINDIR}/"vpndownloader \"\$*\" || ERRVAL=\$?" >> "${D}${BINDIR}/vpndownloader.sh"
		echo "exit \${ERRVAL}" >> "${D}${BINDIR}/vpndownloader.sh"
		chmod 444 "${D}${BINDIR}/vpndownloader.sh"
	else
		ewarn "vpndownloader does not exist. It will not be installed."
	fi

	dodir "${INSTPREFIX}/lib"
	exeinto "${INSTPREFIX}/lib"     # rpath is '/opt/cisco/vpn/lib' (but not lib64)
	doexe "${S}/libssl.so.0.9.8"
	doexe "${S}/libcrypto.so.0.9.8"

	# Profile schema and example template
	doins "${S}/AnyConnectLocalPolicy.xsd"

	insinto "${PROFILEDIR}"
	doins "${S}/AnyConnectProfile.xsd"
	doins "${S}/AnyConnectProfile.tmpl"

	# Attempt to install the init script in the proper place
	newinitd "${S}/vpnagentd_init" vpnagentd
}

pkg_postinst() {
	ewarn "You will need to generate/update the VPNManifest.dat file:"
	ewarn "${BINDIR}/manifesttool -i ${INSTPREFIX} ${INSTPREFIX}/VPNManifestClient.xml"
}
