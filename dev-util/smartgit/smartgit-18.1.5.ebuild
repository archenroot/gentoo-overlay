# Copyright 2015-2017 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils
# xdg: src_prepare, pkg_preinst, pkg_postinst, pkg_postrm
inherit xdg

VENDOR="syntevo"

DESCRIPTION="Git client with support for GitHub Pull Requests+Comments, SVN and Mercurial"
HOMEPAGE="https://www.${VENDOR}.com/${PN}"
LICENSE="smartgit free-noncomm MIT EPL-1.0 Apache-2.0 LGPL-2.1"

# slot number is based on the upstream slotting mechanism which creates a new subdir
# in `~/.smartgit` for each new major release. The subdir name corresponds with SLOT.
SLOT="8"
PN_SLOTTED="${PN}${SLOT}"
# upstream use these types of download uris so far:
# 	https://www.syntevo.com/static/smart/download/smartgit/smartgit-linux-8_0_1.tar.gz
# 	https://www.syntevo.com/static/smart/download/smartgithg/archive/smartgit-linux-7_1_4.tar.gz
SRC_URI="https://www.${VENDOR}.com/static/smart/download/${PN}/${PN}-linux-${PV//./_}.tar.gz"
SRC_URI="https://www.syntevo.com/downloads/smartgit/smartgit-linux-18_1_5.tar.gz"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.7
	|| ( dev-vcs/git dev-vcs/mercurial )
"

RESTRICT+=" mirror strip"

S="${WORKDIR}/${PN}"

src_install() {
	local install_dir="/opt/${VENDOR}/${PN_SLOTTED}"

	## copy files to the install image
	insinto "${install_dir}"
	doins -r .

	## install icons
	local s
	for s in 32 48 64 128 256 ; do
		newicon -s ${s} "bin/${PN}-${s}.png" "${PN_SLOTTED}.png"
	done

	## make scripts executable
	chmod -v a+x "${ED%/}${install_dir}/"{bin,lib}/*.sh || die

	## install symlink to /usr/bin
	dosym "${install_dir}/bin/${PN}.sh" "/usr/bin/${PN_SLOTTED}"

	## generate .desktop entry
	local make_desktop_entry_args=(
		"${PN_SLOTTED} %U"	# exec
		"SmartGit ${SLOT}"	# name
		"${PN_SLOTTED}"	# icon
		"Development"	# categories
	)
	local make_desktop_entry_extras=(
	)
	make_desktop_entry "${make_desktop_entry_args[@]}" \
		"$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"
}

pkg_postinst() {
	elog "${PN} relies on external git/hg executables to work."
	optfeature "Git support" dev-vcs/git
	optfeature "Mercurial support" dev-vcs/mercurial

	xdg_pkg_postinst
}
