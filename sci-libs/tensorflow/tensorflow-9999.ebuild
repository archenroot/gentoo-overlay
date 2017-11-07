# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit eutils multiprocessing distutils-r1 git-r3

DESCRIPTION="Library for Machine Intelligence"

HOMEPAGE="https://www.tensorflow.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tensorflow/tensorflow"
#EGIT_COMMIT="efe5376f3dec8fcc2bf3299a4ff4df6ad3591c88"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="-cuda -opencl"
RESTRICT="primaryuri"

RDEPEND="
	>=dev-python/numpy-1.11.2-r1
	>=dev-python/six-1.10.0
	cuda? (
          >=dev-libs/nvidia-cuda-cudnn-8.0
	  >=dev-util/nvidia-cuda-toolkit-8.0.61
          >=x11-drivers/nvidia-drivers-3.78.13
        )
"

DEPEND="
	>=dev-python/setuptools-34.3.3
	>=dev-util/bazel-0.7.0[tools]
	>=dev-java/oracle-jdk-bin-1.8.0.152-r1
	>=dev-python/pip-9.0.1-r1
	>=dev-python/wheel-0.29.0
	>=dev-lang/swig-3.0.12
	${RDEPEND}
"

#src_prepare() {
	#sed -i -e 's/protobuf == 3.0.0a3/protobuf >= 2.6.0/g' \
	#tensorflow/tools/pip_package/setup.py
#}

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
	elog "Compile Phase - Starting"
	local JAVA_HOME_DECL="$(java-config --print oracle-jdk-bin-1.8 | grep JAVA_HOME)"
	eval "export $JAVA_HOME_DECL"

	# Add /proc/self to avoid a sandbox breakage
	local -x SANDBOX_WRITE="${SANDBOX_WRITE}"
	echo "SANDBOX_WRITE=$SANDBOX_WRITE"
	addwrite /proc/self
	# Added from bazel ebuild.. I am blind here as I don't understand deeply bazel itself :-)
	addpredict /proc
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
	 -c opt //tensorflow/tools/pip_package:build_pip_package
	 elog "Compile Phase - Bazel build finished"
}

src_install() {
	elog "Install Phase - Starting"
	bazel-bin/tensorflow/tools/pip_package/build_pip_package "$PWD/tensorflow_pkg"
	elog "Install Phase - PIP package finished"
	pip install --root "${ED}" "$PWD/tensorflow_pkg/*.whl"
	elog "Install Phase - PIP install finished"
	rm -rf "${ED}"/usr/lib*/python*/site-packages/google/protobuf
	elog "Install Phase - removal of some files"
}
