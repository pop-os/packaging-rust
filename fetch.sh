#!/bin/bash

set -ex

SHASUM_x86_64=a6be5d045183a0b12dddf0d81633e2a64e63e4c2dfa44eb7593970c1ef93a98f
SHASUM_AARCH64=69792887357c8dd78c5424f0b4a624578296796d99edf6c30ebe2acc2b939aa3

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