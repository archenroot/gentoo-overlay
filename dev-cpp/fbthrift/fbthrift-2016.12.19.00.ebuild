 # cat dev-cpp/fbthrift/fbthrift-0.31.0.ebuild 
EAPI=5 

AUTOTOOLS_IN_SOURCE_BUILD=1 
AUTOTOOLS_AUTORECONF=1 
inherit git-r3 autotools-utils 

DESCRIPTION="" 
HOMEPAGE="https://github.com/facebook/fbthrift" 
inherit git-r3 
EGIT_REPO_URI="https://github.com/facebook/fbthrift.git" 
EGIT_REPO_COMMIT="8ede0e0dd6624bbc308e21d3c26e3df80758a92c"
KEYWORDS="~amd64" 

LICENSE="Apache-2.0" 
SLOT="0" 
IUSE="static-libs" 

DEPEND="dev-cpp/folly 
      sys-process/numactl 
      dev-cpp/wangle" 
RDEPEND="${DEPEND}" 

S="${WORKDIR}/${P}/thrift" 

src_configure() { 
   autotools-utils_src_prepare 
    PYTHON=2 PYTHON_VERSION=2 econf 
   #epatch "${FILESDIR}/gcc.patch" 
} 
