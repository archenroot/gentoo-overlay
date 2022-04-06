# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: jetbrains-ide.eclass
# @MAINTAINER:
# 2xsaiko <me@dblsaiko.net>
# @AUTHOR:
# 2xsaiko <me@dblsaiko.net>
# @BLURB: common code for JetBrains IDEs
# @DESCRIPTION:
#

inherit desktop

EXPORT_FUNCTIONS src_unpack src_prepare src_install

# @ECLASS-VARIABLE: IDE_FULL_NAME
# @DESCRIPTION:
# The full name of the IDE, as it will appear in the desktop entry.
# @EXAMPLE:
#
# @CODE
# IDE_FULL_NAME="IntelliJ IDEA"
# @CODE

# @ECLASS-VARIABLE: IDE_BIN_NAME
# @DESCRIPTION:
# The binary name of the IDE: the name of the launch script and icon in bin/
# @EXAMPLE:
#
# @CODE
# IDE_BIN_NAME="idea"
# @CODE

# @ECLASS-VARIABLE: IDE_DIST_NAME
# @DESCRIPTION:
# The name of the IDE as it appears in the top-level directory in the
# distribution archive.
# @EXAMPLE:
#
# @CODE
# IDE_DIST_NAME="idea-IU"
# @CODE
: ${IDE_DIST_NAME:=${PN}}

# @ECLASS-VARIABLE: IDE_DIST_VERSION
# @DESCRIPTION:
# The version of the IDE as it appears in the top-level directory in the
# distribution archive, or "any" if unknown (which can be used for IDEs that are
# named by their internal build version here)
: ${IDE_DIST_VERSION:=${PV}}


RDEPEND="
	dev-util/jetbrains-common
	dev-java/jansi-native
	dev-libs/libdbusmenu"

RESTRICT="strip splitdebug mirror"

jetbrains-ide_src_unpack() {
	default_src_unpack

	if [[ "${IDE_DIST_VERSION}" = "any" ]]; then
		mv "${IDE_DIST_NAME}"-* "${P}"
	else
		mv "${IDE_DIST_NAME}-${IDE_DIST_VERSION}" "${P}"
	fi
}

jetbrains-ide_src_prepare() {
	if [[ -d "${S}/jbr" ]]; then
		rm -r "${S}/jbr"
	fi

	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/{aarch64,mips64el,ppc64le}
	rm -vf "${S}"/bin/libdbm64*

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	eapply_user
}

jetbrains-ide_src_install() {
	if [[ "${IDE_FULL_NAME}" = "" ]]; then
		die "must set IDE_FULL_NAME before calling jetbrains-ide_src_install!"
	fi

	if [[ "${IDE_BIN_NAME}" = "" ]]; then
		die "must set IDE_BIN_NAME before calling jetbrains-ide_src_install!"
	fi

	local dir="/opt/${P}"
	dodir "${dir}"
	cp -a "${S}"/* "${ED}/${dir}/"

	dosym "${dir}/bin/${IDE_BIN_NAME}.sh" "/usr/bin/${PN}"
	dosym "${dir}/bin/${IDE_BIN_NAME}.svg" "/usr/share/pixmaps/${PN}.svg"
	make_desktop_entry "${PN}" "${IDE_FULL_NAME}" "${PN}" "Development;IDE;" "StartupWMClass=jetbrains-${IDE_BIN_NAME}"
}
