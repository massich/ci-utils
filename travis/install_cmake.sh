#!/bin/sh

# This script installs CMake. It requres a valid CMAKE_VERSION variable
#
# In .travis.yml, add this:
#  - CMAKE_VERSION=3.10.1
#  - sh -c "$(curl -fsSkL https://raw.githubusercontent.com/openmeeg/ci-utils/master/travis/install_mkl.sh)"

set -ex

if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
    CMAKE_URL="https://cmake.org/files/v${CMAKE_VERSION%.[0-9]}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz"
    mkdir cmake && travis_retry wget --no-check-certificate -O - ${CMAKE_URL} | tar --strip-components=1 -xz -C cmake
    export PATH=${DEPS_DIR}/cmake/bin:${PATH}
else
    brew upgrade cmake
fi
