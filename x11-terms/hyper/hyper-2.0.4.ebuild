# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils gnome2-utils xdg
DESCRIPTION="JS/HTML/CSS Terminal (Pre-release)"
HOMEPAGE="https://hyper.is/"
SRC_URI="https://github.com/zeit/hyper/archive/${PV}.tar.gz -> hyper-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
DEPEND="
	media-gfx/graphicsmagick
	media-libs/libicns
	sys-apps/yarn"
RDEPEND="app-arch/xz-utils"
RESTRICT="mirror"

QA_PRESTRIPPED="/opt/Hyper/libnode.so
		/opt/Hyper/libffmpeg.so
		/opt/Hyper/hyper"

src_prepare() {
	einfo "Please create /usr/etc if you're using nodejs <=5.6.0,"
	einfo "as NPM otherwise tries to create it, violating the sandbox rules."
	einfo "See https://github.com/npm/npm/issues/11486"
	yarn install || yarn run rebuild-node-pty \
		&& yarn install || die "yarn dependency instllation failed!" # Not a nice solution, but it works for now

	# Don't build RPMs & DEBs
	sed -i 's/"build": {/"donotbuild": {/g' package.json

	eapply_user
}

src_compile() {
	yarn run dist || die "yarn packaging failed!"
}

src_install() {
    elog "destination: ${D}"
    elog "root: ${ROOT}"
	elog "destdir: ${destdir}"
	elog "insdir: ${insdir}"
	local destdir="/opt/Hyper"
	local insdir="dist/linux-unpacked"
	insinto $destdir
	
	elog "destination: ${D}"
    elog "root: ${ROOT}"
	elog "destdir: ${destdir}"
	elog "insdir: ${insdir}"
	elog "$FILESDIR"
	doins -r $insdir/locales $insdir/resources
	doins	$insdir/blink_image_resources_200_percent.pak \
		$insdir/content_resources_200_percent.pak \
		$insdir/ui_resources_200_percent.pak \
		$insdir/views_resources_200_percent.pak \
		$insdir/content_shell.pak \
		$insdir/icudtl.dat \
		$insdir/natives_blob.bin \
		$insdir/snapshot_blob.bin \
		$insdir/libnode.so \
		$insdir/libffmpeg.so

	exeinto $destdir
	doexe $insdir/hyper
	dosym $destdir/hyper /usr/bin/hyper
	insinto /usr/share/icons
	doins -r "$FILESDIR"/hicolor
	insinto /usr/share/applications
	doins "$FILESDIR"/hyper.desktop
# Install missing JS artefacts from BIN folder
	local destdir="/opt/Hyper/resources"
	local insdir="${S}"
	insinto $destdir
	doins -r $insdir/bin
	
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	einfo "You might have to add fs.inotify.max_user_watches=524288"
	einfo "or something similiar"
	einfo "see https://github.com/zeit/hyper/issues/1502"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
