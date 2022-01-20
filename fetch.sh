#!/bin/bash

set -ex

SHASUM_x86_64=4fac6df9ea49447682c333e57945bebf4f9f45ec7b08849e507a64b2ccd5f8fb
SHASUM_AARCH64=ce557516593e4526709b0f33c2e1d7c932b3ddf76af94c2417d8d667921ce90c

TARGET="$1"
VERSION="$2"

function fetch () {
    RUST_TRIPLE="${1}-unknown-linux-gnu"
    FILENAME="rust-${VERSION}-${RUST_TRIPLE}"
    FETCHED_FILE="${TARGET}/${FILENAME}.tar.gz"

    curl --create-dirs -O "https://static.rust-lang.org/dist/${FILENAME}.tar.gz"
}

function validate() {
    RUST_TRIPLE="${1}-unknown-linux-gnu"
    FILENAME="rust-${VERSION}-${RUST_TRIPLE}"
    FETCHED_FILE="${FILENAME}.tar.gz"

    # Validate that the toolchain we downloaded matches the expected SHA256 checksum.
    if test "x86_64" = "${1}"; then
        test "${SHASUM_x86_64}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
    elif test "aarch64" = "${1}"; then
        test "${SHASUM_AARCH64}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
    else
        return 1
    fi
}

rm -rf ${TARGET}
mkdir -p ${TARGET}
cd ${TARGET}

fetch x86_64
validate x86_64

fetch aarch64
validate aarch64
