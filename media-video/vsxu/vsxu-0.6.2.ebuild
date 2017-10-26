# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3 or later
# Author: Jonas Jelten <jonas.jelten@gmail.com>

EAPI=5
inherit git-2 cmake-utils

DESCRIPTION="A free to use program that lets you create and perform real-time audio visual presets."
HOMEPAGE="http://www.vsxu.com/"
EGIT_REPO_URI="https://github.com/vovoid/vsxu.git"
EGIT_COMMIT="$PV"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opencv"
#opencv will automagically be used by cmake, this just controls the dependency.

DEPEND="media-libs/glew media-libs/ftgl media-libs/glfw media-sound/pulseaudio virtual/jpeg media-libs/libpng x11-themes/hicolor-icon-theme x11-misc/xdg-utils x11-libs/libXrandr opencv? ( media-libs/opencv )"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "$WORKDIR"
	find . -name cmake_packages.txt -exec sed -i 's/PNG 12 EXACT/PNG/' {} \;
}
