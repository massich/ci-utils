#!/bin/sh

# This script installs CMake. It requres a valid SWIG_VERSION variable
#
# In .travis.yml, add this:
#  - SWIG_VERSION=4.0.1
#  - sh -c "$(curl -fsSkL https://raw.githubusercontent.com/openmeeg/ci-utils/master/travis/install-swig.sh)"


if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
    swig_dir=${DEPS_DIR}/swig
    pushd ${DEPS_DIR}
    SWIG_URL="https://sourceforge.net/projects/swig/files/swig/swig-${SWIG_VERSION}/swig-${SWIG_VERSION}.tar.gz"
    mkdir swig-src && travis_retry wget --no-check-certificate -O - ${SWIG_URL} | tar --strip-components=1 -C swig-src -xz
    (cd swig-src && ./autogen.sh)
    (mkdir swig-build && cd swig-build && ../swig-src/configure --prefix=${swig_dir} && make && make install)
    export PATH=${swig_dir}/bin:${PATH}
    popd
fi
