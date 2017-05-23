# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#EGIT_REPO_URI="git://github.com/BVLC/caffe.git"
#EGIT_REPO_URI="git://github.com/NVIDIA/caffe"
# Original repository commit
#EGIT_REPO_COMMIT="eeebdab16155d34ff8f5f42137da7df4d1c7eab0"

# ArchenRoot fork of Caffe
EGIT_REPO_URI="https://github.com/archenroot/caffe.git"
EGIT_REPO_COMMIT="bd3d2b1176755d9319c538e0d64563b9e11a54f6"
# python2_7 removed as it caused exception about missing Python.h file in compile time
PYTHON_COMPAT=( python3_4)

inherit toolchain-funcs multilib git-r3 python-single-r1
# Can't use cuda.eclass as nvcc does not like --compiler-bindir set there for some reason

DESCRIPTION="Deep learning framework by the BVLC"
HOMEPAGE="http://caffe.berkeleyvision.org/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+cuda +python"

CDEPEND="
	dev-libs/boost:=[python?]
	media-libs/opencv:=
	dev-libs/protobuf:=[python?]
	dev-cpp/glog:=
	dev-cpp/gflags:=
	sci-libs/hdf5:=
	dev-libs/leveldb:=
	app-arch/snappy:=
	dev-db/lmdb:=
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
	python? (
		${PYTHON_DEPS}
	)
"
DEPEND="
	${CDEPEND}
	sys-devel/bc
"
RDEPEND="
	${CDEPEND}
	python? (
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		media-gfx/pydot[${PYTHON_USEDEP}]
		sci-libs/scikits_image[${PYTHON_USEDEP}]
	)
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_configure() {
	# Respect CFLAGS
	sed -e '/COMMON_FLAGS/s/-O2//' -i Makefile

	cat > Makefile.config << EOF
BLAS := atlas
BUILD_DIR := build
DISTRIBUTE_DIR := distribute

USE_PKG_CONFIG := 1

LIBRARY_NAME_SUFFIX := -nv
EOF

	if use cuda; then
		cat >> Makefile.config << EOF
CUDA_DIR := "${EPREFIX}/opt/cuda"

CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
			 -gencode arch=compute_20,code=sm_21 \
			 -gencode arch=compute_30,code=sm_30 \
			 -gencode arch=compute_35,code=sm_35 \
			 -gencode arch=compute_50,code=sm_50 \
			 -gencode arch=compute_50,code=compute_50
CUDA_ARCH := -gencode arch=compute_50,code=sm_50 \
             -gencode arch=compute_50,code=compute_50
EOF

		# This should be handled by Makefile itself, but somehow is broken
		sed -e "/CUDA_LIB_DIR/s/lib/$(get_libdir)/" -i Makefile || die "sed failed"
	else
		echo "CPU_ONLY := 1" >> Makefile.config
	fi

	if use python; then
		python_export PYTHON_INCLUDEDIR PYTHON_SITEDIR PYTHON_LIBPATH
		cat >> Makefile.config << EOF

PYTHON_INCLUDE := "${PYTHON_INCLUDEDIR}" "${PYTHON_SITEDIR}/numpy/core/include"
PYTHON_LIB := "$(dirname ${PYTHON_LIBPATH})"
WITH_PYTHON_LAYER := 1

INCLUDE_DIRS += \$(PYTHON_INCLUDE)
LIBRARY_DIRS += \$(PYTHON_LIB)
EOF

		local py_version=${EPYTHON#python}
		sed -e "/PYTHON_LIBRARIES/s/python\s/python-${py_version} /g" \
			-i Makefile || die "sed failed"
	fi

	sed -e '/blas/s/atlas//' \
		-e '/^LINKFLAGS +=/ a\
		LINKFLAGS += -L$(LIB_BUILD_DIR)
		' \
		-i Makefile || die "sed failed"

	tc-export CC CXX
}

src_compile() {
	emake

	use python && emake pycaffe
}

src_test() {
	emake runtest

	use python && emake pytest
}

src_install() {
	emake distribute

	for bin in distribute/bin/*; do
		local name=$(basename ${bin})
		newbin ${bin} ${name//.bin/}
	done

	insinto /usr
	doins -r distribute/include/

	dolib.a distribute/lib/libcaffe*.a*
	dolib.so distribute/lib/libcaffe*.so*

	if use python; then
		rm distribute/python/caffe/_caffe.cpp || die "rm failed"
		python_domodule distribute/python/caffe
		for script in distribute/python/*.py; do
			python_doscript ${script}
		done
	fi
}
