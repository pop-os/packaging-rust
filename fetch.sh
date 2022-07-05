#!/bin/bash

set -e

SHASUM_x86_64=4172d3cb316498025410bdf33a4d0f756f5e77fbaee1fb042ccdef78239be1db
SHASUM_AARCH64=eb15623acab56523bab68826db03c66f926adb6376363dd5e2a8801a16bc4542

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

function fetch_target() {
    validate ${1} || (fetch ${1} && validate ${1})
}

fetch_target x86_64
fetch_target aarch64