# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit java-pkg-2 java-ant-2 subversion

DESCRIPTION="Platform Independent Tool to Download Files from One-Click-Hosting Sites"
HOMEPAGE="http://jdownloader.org"

# Workaround for single-valued ESVN_REPO_URI
# (s. src_unpack())
ESVN_REPO_URI_JD="svn://svn.jdownloader.org/jdownloader/trunk"
ESVN_REPO_URI_AW_UTILS="svn://svn.appwork.org/utils"
ESVN_REPO_URI_AW_UPDCLIENT="svn://svn.appwork.org/updclient"
ESVN_REPO_URI_JD_BROWSER="svn://svn.jdownloader.org/jdownloader/browser"

ESVN_REPO_URI="${ESVN_REPO_URI_JD}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-java/ant
	>=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="pack_linux"

src_unpack() {
	subversion_fetch "${ESVN_REPO_URI}" jdownloader
	subversion_fetch "${ESVN_REPO_URI_AW_UTILS}" appwork-utils
	mv "${S}"/appworkutils/utils jdownloader/AppWorkUtils
	#subversion_fetch "${ESVN_REPO_URI_AW_UPDCLIENT}" appwork-updclient
	#subversion_fetch "${ESVN_REPO_URI_JD_BROWSER}" jd-browser
}

src_compile() {
	#cd "${S}/appwork-utils"
	#java-pkg-2_src_compile
	#cd "${S}/appwork-updclient"
	#java-pkg-2_src_compile
	#cd "${S}/jd-browser"
	#java-pkg-2_src_compile
	cd "${S}/jdownloader"
	java-pkg-2_src_compile
}
