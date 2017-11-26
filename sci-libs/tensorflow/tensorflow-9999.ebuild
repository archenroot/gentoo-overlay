# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit eutils multiprocessing distutils-r1 git-r3

DESCRIPTION="Library for Machine Intelligence"

HOMEPAGE="https://www.tensorflow.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tensorflow/tensorflow"
EGIT_COMMIT="c9568f1ee51a265db4c5f017baf722b9ea5ecfbb"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="-cuda -opencl"
RESTRICT="primaryuri"

RDEPEND="
	>=dev-python/numpy-1.11.2-r1
	>=dev-python/six-1.10.0
	cuda? (
          >=dev-libs/nvidia-cuda-cudnn-7.0
	  >=dev-util/nvidia-cuda-toolkit-8.0.61
          >=x11-drivers/nvidia-drivers-3.78.13
        )
"

DEPEND="
	dev-python/setuptools
	>=dev-util/bazel-0.7.0[tools]
	>=dev-java/oracle-jdk-bin-1.8.0.152-r1
	>=dev-python/markdown-2.6.9
	>=dev-python/werkzeug-0.12.2
	>=dev-python/bleach-1.5.0
	>=dev-python/protobuf-python-3.4.1
	>=dev-python/pip-9.0.1-r1
	>=dev-python/wheel-0.29.0
	>=dev-lang/swig-3.0.12
	>=dev-python/absl-py-0.1.4
	${RDEPEND}
"

#src_prepare() {
	#sed -i -e 's/protobuf == 3.0.0a3/protobuf >= 2.6.0/g' \
	#tensorflow/tools/pip_package/setup.py
#}

src_configure() {
	local ALFA="$(find /tmp/empty* -type f -exec sh -c 'echo $(basename {})' \;)"

	elog "!!!!!! CHECK ${ALFA}"
	export CUDNN_INSTALL_PATH="/usr/lib64"
	export TF_NEED_CUDA="1"
	export TF_CUDA_VERSION="9.0"
	export TF_CUDNN_VERSION="7"
	yes "" | ./configure

	cat > CROSSTOOL << EOF
tool_path {
	name: "gcc"
	path: "${CC}"
}
tool_path {
	name: "g++"
	path: "${CXX}"
EOF

	echo "Will build with $(makeopts_jobs) jobs"

}

src_compile() {
	addwrite /proc/self
	# Added from bazel ebuild.. I am blind here as I don't understand deeply bazel itself :-)
	addpredict /proc
	elog "Compile Phase - Starting"

	local JAVA_HOME_DECL="$(java-config --print oracle-jdk-bin-1.8 | grep JAVA_HOME)"
	eval "export $JAVA_HOME_DECL"

	# Add /proc/self to avoid a sandbox breakage
	local -x SANDBOX_WRITE="${SANDBOX_WRITE}"
	echo "SANDBOX_WRITE=$SANDBOX_WRITE"

	elog "Compile Phase - SANDBOX_WRITE"

	cat > bazelrc << EOF
startup --batch
build --spawn_strategy=standalone --genrule_strategy=standalone
build --jobs $(makeopts_jobs)
EOF
	export BAZELRC="$PWD/bazelrc"
	elog "Compile Phase - Bazel configured"
	bazel build \
	 --spawn_strategy=standalone --genrule_strategy=standalone \
	 --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
	 elog "Compile Phase - Bazel build finished"
}

src_install() {
	elog "Install Phase - Starting"
	bazel-bin/tensorflow/tools/pip_package/build_pip_package "$PWD/tensorflow_pkg"
	elog "Install Phase - PIP package finished"
	local ALFA="$(find /tmp/empty* -type f -exec sh -c 'echo $(basename {})' \;)"
	local TENSORFLOW_WHEEL_FILE="$(find $PWD/tensorflow_pkg/tensorflow* -type f -exec sh -c 'echo $(basename {})' \;)"
	pip install --root "${ED}" "$PWD/tensorflow_pkg/$TENSORFLOW_WHEEL_FILE"
	elog "Install Phase - PIP install finished"
	rm -rf "${ED}"/usr/lib*/python*/site-packages/google/protobuf
	elog "Install Phase - removal of some files"
}
