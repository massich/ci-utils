#!/bin/sh

# This script installs CMake. It requires a valid CMAKE_VERSION variable
#
# In .travis.yml, add this:
#  - CMAKE_VERSION=3.10.1
#  - sh -c "$(curl -fsSkL https://raw.githubusercontent.com/openmeeg/ci-utils/master/travis/install_cmake.sh)"


if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
    cmake_dir=${DEPS_DIR}/cmake
    mkdir -p ${cmake_dir}
    pushd ${DEPS_DIR}
    CMAKE_URL="https://cmake.org/files/v${CMAKE_VERSION%.[0-9]}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz"
    mkdir cmake && travis_retry wget --no-check-certificate -O - ${CMAKE_URL} | tar --strip-components=1 -xz -C cmake
    ls -lR ${cmake_dir}
    export PATH=${cmake_dir}/bin:${PATH}
    popd
else
    brew upgrade cmake
fi
