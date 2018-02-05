#!/bin/sh

# This script installs Travis helper functions and tools used in openmeeg repositories
#
# To use them, add the following lines in .travis.yml:
#  - export DL_DIR=$HOME/downloads # Export the path where to store downloaded files
#  - sh -c "$(curl -fsSkL https://raw.githubusercontent.com/openmeeg/ci-utils/master/travis/travis_tools.sh)"

set -ex

function _download() {
    url="$1"; f="${2:-$(basename $url)}";
    if [ ! -e $DL_DIR/$f ] ; then
        mkdir -p $DL_DIR ;
        echo "Downloading: ${DL_DIR}/$f" ;
        travis_retry wget --no-verbose $url -O $DL_DIR/$f ;
    else
        echo "Reading from cache: ${DL_DIR}/$f" ;
    fi
}

function download() { _download "$1" "" ; }
