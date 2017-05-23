# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_{6,7} pypy2_0 )

inherit eutils multiprocessing distutils-r1 git-r3

DESCRIPTION="Library for Machine Intelligence"

HOMEPAGE="https://www.tensorflow.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tensorflow/tensorflow"
EGIT_COMMIT="efe5376f3dec8fcc2bf3299a4ff4df6ad3591c88"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
RESTRICT="primaryuri"

RDEPEND="
"

DEPEND="
	>=dev-python/setuptools-34.3.3
	>=dev-util/bazel-0.4.5[tools]
	>=dev-python/pip-9.0.1-r1
	>=dev-python/numpy-1.11.2-r1
	>=dev-python/wheel-0.29.0
	>=dev-python/six-1.10.0
	>=dev-lang/swig-3.0.8
	>=x11-drivers/nvidia-drivers-3.78.13
	>=dev-util/nvidia-cuda-toolkit-8.0.61
	>=dev-libs/nvidia-cuda-cudnn-8.0
"

src_prepare() {
	sed -i -e 's/protobuf == 3.0.0a3/protobuf >= 2.6.0/g' \
	tensorflow/tools/pip_package/setup.py
}

src_configure() {
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
	local JAVA_HOME_DECL="$(java-config --print oracle-jdk-bin-1.8 | grep JAVA_HOME)"
	eval "export $JAVA_HOME_DECL"

	# Add /proc/self to avoid a sandbox breakage
	local -x SANDBOX_WRITE="${SANDBOX_WRITE}"
	echo "SANDBOX_WRITE=$SANDBOX_WRITE"
	addwrite /proc/self

	cat > bazelrc << EOF
startup --batch
build --spawn_strategy=standalone --genrule_strategy=standalone
build --jobs $(makeopts_jobs)
EOF
	export BAZELRC="$PWD/bazelrc"

	bazel build \
	 --spawn_strategy=standalone --genrule_strategy=standalone \
	 -c opt //tensorflow/tools/pip_package:build_pip_package
}

src_install() {
	bazel-bin/tensorflow/tools/pip_package/build_pip_package "$PWD/tensorflow_pkg"
	pip install --root "${ED}" "$PWD/tensorflow_pkg/*.whl"
	rm -rf "${ED}"/usr/lib*/python*/site-packages/google/protobuf
}
