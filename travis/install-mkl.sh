#!/bin/sh

# This script installs Intel's Math Kernel Library (MKL) on Travis (both Linux and Mac)
#
# In .travis.yml, add this:
#
#  - sh -c "$(curl -fsSkL https://raw.githubusercontent.com/openmeeg/ci-utils/master/travis/install_mkl.sh)"
#
# Note:
# This script requires the openmeeg's travis tools from https://gist.github.com/massich/f382ec0181ce6603b38208f9dec3e4d4

set -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
  sudo dpkg --add-architecture i386
  wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
  sudo apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
  rm GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
  sudo wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list
  sudo sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
  sudo apt-get update

  # FindMKL.cmake uses mkl_link_tool, which is a 32bits application !
  sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
  dpkg -l | grep binutils
  apt-cache policy binutils
  sudo apt-get install binutils-2.26
  export PATH=/usr/lib/binutils-2.26/bin:${PATH}
  sudo apt-get install intel-mkl-64bit-2020.0-088

else  # Mac
  export MKL_INSTALL_DIR=/opt/intel
  export ARCH_FNAME=m_mkl_2018.4.231.dmg
  travis_wait 30 download http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13634/${ARCH_FNAME}
  hdiutil attach $DL_DIR/${ARCH_FNAME}
  cat /Volumes/m_mkl_2018.4.231/m_mkl_2018.4.231.app/Contents/MacOS/silent.cfg | grep -v EULA | grep -v PSET_INSTALL_DIR > silent.cfg
  echo "ACCEPT_EULA=accept" >> silent.cfg
  echo "PSET_INSTALL_DIR=${MKL_INSTALL_DIR}" >> silent.cfg
  sudo /Volumes/m_mkl_2018.4.231/m_mkl_2018.4.231.app/Contents/MacOS/install.sh -s ./silent.cfg
  . /opt/intel/mkl/bin/mklvars.sh intel64 ilp64

fi
