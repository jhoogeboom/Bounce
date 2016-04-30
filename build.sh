#!/bin/bash
# Windows - use gow - https://github.com/bmatzelle/gow/releases
# Build.sh - only needed if:
#   * You change the libraries in bounce_base.js
#   * You wish to update to another version of google closure.
#   * Changing the compile options

set -eu -o pipefail

function install_deps() {
    echo "Retrieving dependencies"
    echo ${DEPS_DIR}
    mkdir -p ${DEPS_DIR}
    pushd ${DEPS_DIR}
    if [ ! -d compiler ]; then
        wget -nc http://dl.google.com/closure-compiler/compiler-latest.zip && mkdir compiler && unzip compiler-latest.zip -d compiler
    fi
    if [ ! -d closure-library-20160315 ]; then
        wget -nc https://github.com/google/closure-library/archive/v20160315.tar.gz -O closure-library.tgz && tar -xzf closure-library.tgz
    fi
    popd
    echo "Dependencies prepared"
}

function prepare_output_dir() {
    mkdir -p ${OUTPUT_DIR}
    ./${SCRIPTS_DIR}/make_compressed.sh
    ./${SCRIPTS_DIR}/assemble_output.sh
}

export DEPS_DIR=deps
export OUTPUT_DIR=output
export SRC_DIR=Bounce
export SCRIPTS_DIR=scripts
export CLOSURE_DIR=deps/closure-library-20160315

# New system - deps go into deps folder
# Compressed files go into Bounce folder
#


# Download and install 3rd party deps
install_deps
# Prepare compressed output
# Minify CSS from 3rd party stuff - put in output.



prepare_output_dir

rm bounce.zip || true
zip -r bounce.zip ${OUTPUT_DIR}

#Todo
#chrome.exe --pack-extension=${OUTPUT_DIR} --pack-extension-key=C:\myext.pem