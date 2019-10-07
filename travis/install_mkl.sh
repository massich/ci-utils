#!/bin/sh

# This script installs Intel's Math Kernel Library (MKL) on Travis (both Linux and Mac)
#
# In .travis.yml, add this:
#
#  - sh -c "$(curl -fsSkL https://raw.githubusercontent.com/openmeeg/ci-utils/master/travis/install_mkl.sh)"
#
# Note:
# This script requires the openmeeg's travis tools from https://gist.github.com/massich/f382ec0181ce6603b38208f9dec3e4d4

if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
  export MKL_INSTALL_DIR=$(pwd)/intel
  export ARCH_FNAME=l_mkl_2018.0.128.tgz
  travis_wait 30 download http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12070/${ARCH_FNAME}
  tar -xzf $DL_DIR/${ARCH_FNAME}
  cat l_mkl_2018.0.128/silent.cfg | grep -v EULA | grep -v PSET_INSTALL_DIR > silent.cfg
  echo "ACCEPT_EULA=accept" >> silent.cfg
  echo "PSET_INSTALL_DIR=${MKL_INSTALL_DIR}" >> silent.cfg
  ./l_mkl_2018.0.128/install.sh --user-mode -s ./silent.cfg
  export LD_LIBRARY_PATH="${MKL_INSTALL_DIR}/mkl/lib/intel64/:${LD_LIBRARY_PATH}"
  . ${MKL_INSTALL_DIR}/mkl/bin/mklvars.sh intel64 ilp64

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
