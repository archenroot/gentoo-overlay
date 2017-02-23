 # cat dev-cpp/fbthrift/fbthrift-0.31.0.ebuild 
EAPI=6

AUTOTOOLS_IN_SOURCE_BUILD=1 
AUTOTOOLS_AUTORECONF=1 
inherit cmake-utils git-r3 

DESCRIPTION="" 
HOMEPAGE="https://github.com/facebook/fblualib" 

EGIT_REPO_URI="https://github.com/facebook/fblualib.git"
KEYWORDS="~amd64" 

LICENSE="Apache-2.0" 
SLOT="0" 
IUSE="doc +fbthrift +folly" 

COMMON_DEPEND="sci-libs/torch7
				fbthrift? ( dev-cpp/fbthrift )
				folly? ( dev-cpp/folly )"
DEPEND="${COMMON_DEPEND}
		dev-cpp/folly" 
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/fblualib"
echo "working dir ${S} "
CMAKE_VERBOSE="ON"

src_prepare() {
	
	# Fixing compatibility with Facebook folly library where they enforced 
	# append-cflags -std=gnu++14
	# append-cflags -std=c++14
	elog "lua:" $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)
	elog "luajit:" $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD luajit)
	cmake-utils_src_prepare
}
src_configure() { 
echo "Preparing source"
	echo "starting configure phase"
	cmake-utils_src_configure
	echo "finished configure phase"
} 
