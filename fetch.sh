#!/bin/bash

set -e

SHASUM_x86_64=b8a4c3959367d053825e31f90a5eb86418eb0d80cacda52bfa80b078e18150d5
SHASUM_AARCH64=99c419c2f35d4324446481c39402c7baecd7a8baed7edca9f8d6bbd33c05550c

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