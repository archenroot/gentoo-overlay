DESCRIPTION="Facebook TH++: A C++ tensor library"
SLOT="0"

EAPI=6

HOMEPAGE="http://wiki.gentoo.org/index.php?title=Basic_guide_to_write_Gentoo_Ebuilds"

KEYWORDS="~amd64"

EGIT_REPO_URI="https://github.com/facebook/thpp.git"
EGIT_COMMIT="a33971a22d348f15a85c955ad75e75916804112e"

LICENSE="BSD License"

DEPEND="sci-libs/torch7"
RDEPEND=${DEPEND}

S="${WORKDIR}/${P}/thpp"

src_configure(){

}
