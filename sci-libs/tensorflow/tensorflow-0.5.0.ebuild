# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit multilib-build eutils python-r1 distutils-r1 git-2

DESCRIPTION="Open source software library for numerical computation using data flow graphs."
HOMEPAGE="http://www.tensorflow.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tensorflow/tensorflow.git"
EGIT_HAS_SUBMODULES="yes"
if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="${PV}"
fi

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cray cuda +system-protobuf"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	 dev-python/six[${PYTHON_USEDEP}]
"
DEPEND=">=dev-util/bazel-0.1.0
	dev-lang/swig
	${RDEPEND}"

python_prepare() {
	epatch "${FILESDIR}"/0.5.0-adjust-configure.patch

	if use cray; then
		sed -i "s:/bin/bash:/usr/bin/env bash:" third_party/gpus/cuda/cuda_config.sh
		sed -i "s:/usr/bin/gcc:${GCC_PATH}/snos/bin/gcc:" third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc
	fi
	sed -i "s:NVCC_PATH = .*:NVCC_PATH = '$(which nvcc)':" third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc
	sed -i "s:PREFIX_DIR = .*:PREFIX_DIR = '$(dirname $(which as))':" third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc
	for flag in $LDFLAGS; do
		sed -i "114 i   linker_flag: \"${flag}\"" third_party/gpus/crosstool/CROSSTOOL
	done

	python_includes=( "$(${EPYTHON} -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")" "$(${EPYTHON} -c "import numpy; print(numpy.get_include())")" )
	echo "python_includes: $EPYTHON ${python_includes[@]}"
	for dir in ${python_includes[@]}; do
		sed -i "106 i   compiler_flag: \"-I${dir}\"" third_party/gpus/crosstool/CROSSTOOL
	done
	sed -i "s:-Wl,-rpath,third_party/gpus/cuda/lib64:-Wl,-rpath,$CUDATOOLKIT_HOME/lib64:" tensorflow/core/platform/default/build_config/BUILD
	echo "src_prepare"
}

python_configure_all() {
	if use cuda; then
		export TF_NEED_CUDA=1
		export CUDA_TOOLKIT_PATH="$CUDATOOLKIT_HOME"
		save_IFS=$IFS
		IFS=':'
		prefixes="${EPREFIX}:${PORTAGE_READONLY_EPREFIXES}"
		for p in $prefixes; do
			echo "$p"
			if [ -e "${p}/usr/lib/libcudnn.so" ]; then
				prefix=$p
			fi
		done
		IFS=$save_IFS
		export CUDNN_INSTALL_PATH="${prefix}/usr"
		myconfig="--config=cuda"
	else
		export TV_NEED_CUDA=0
		myconfig=""
	fi
	./configure #use econf (?)
	bazel build -c opt $myconfig //tensorflow/tools/pip_package:build_pip_package || ( bazel shutdown )
	mkdir "${T}"/${EPYTHON}_package || ( bazel shutdown )
	bazel-bin/tensorflow/tools/pip_package/build_pip_package "${T}/${EPYTHON}_package" || ( bazel shutdown )
	mkdir "${WORKDIR}"/tensorflow_built-${EPYTHON/./_} || ( bazel shutdown )
	mkdir "${WORKDIR}"/tensorflow_built || ( bazel shutdown )
	tar -xvf "${T}/${EPYTHON}_package"/tensorflow-${PV}.tar.gz -C "${WORKDIR}"/tensorflow_built-${EPYTHON/./_} --strip-components=1 || ( bazel shutdown )
	S="${WORKDIR}/tensorflow_built"
	bazel shutdown
}

python_install() {
	distutils-r1_python_install
	use system-protobuf && rm -rf "${ED}"/usr/lib/${EPYTHON}/site-packages/google/
	rm -rf "${ED}"/usr/lib/${EPYTHON}/site-packages/external/
}
