 # cat dev-cpp/fbthrift/fbthrift-0.31.0.ebuild 
EAPI=5 

AUTOTOOLS_IN_SOURCE_BUILD=1 
AUTOTOOLS_AUTORECONF=1 
inherit cmake-utils git-r3 

DESCRIPTION="" 
HOMEPAGE="https://github.com/archenroot/thpp" 

EGIT_REPO_URI="https://github.com/archenroot/thpp.git"
KEYWORDS="~amd64" 

LICENSE="Apache-2.0" 
SLOT="0" 
IUSE="doc +fbthrift +folly" 

COMMON_DEPEND="sci-libs/torch7
				fbthrift? ( dev-cpp/fbthrift )
				folly? ( dev-cpp/folly )"
DEPEND="${COMMON_DEPEND}
		dev-cpp/folly 
		sys-process/numactl 
		dev-cpp/wangle" 
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/thpp"
echo "working dir ${S} "
CMAKE_VERBOSE="ON"

src_prepare() {
	rm -rf googletest-release-1.7.0 googletest-release-1.7.0.zip
	curl -JLOk https://github.com/google/googletest/archive/release-1.7.0.zip
	if [[ $(sha1sum -b googletest-release-1.7.0.zip | cut -d' ' -f1) != \
	      'f89bc9f55477df2fde082481e2d709bfafdb057b' ]]; then
	  echo "Invalid googletest-release-1.7.0.zip file" >&2
	  die
	else
		echo "we have the googletest at `pwd`"
	fi	
	mv googletest-release-1.7.0.zip ${S}
	unzip ${S}/googletest-release-1.7.0.zip

	# Fixing compatibility with Facebook folly library where they enforced 
	# append-cflags -std=gnu++14
	# append-cflags -std=c++14

	cmake-utils_src_prepare
}
src_configure() { 
echo "Preparing source"
	
	local mycmakeargs=(
		$(cmake-utils_use !fbthrift NO_THRIFT)
		$(cmake-utils_use !folly NO_FOLLY)
	)
	echo "starting configure phase"
	cmake-utils_src_configure
	echo "finished configure phase"
} 
