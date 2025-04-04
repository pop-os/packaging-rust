#!/bin/bash

set -e

BUILD="$1"
VERSION="$2"
shift 2

function fetch () {
    RUST_TRIPLE="${1}-unknown-linux-gnu"
    FILENAME="rust-${VERSION}-${RUST_TRIPLE}"
    FETCHED_FILE="${BUILD}/${FILENAME}.tar.xz"

    curl --create-dirs -O "https://static.rust-lang.org/dist/${FILENAME}.tar.xz"
}

function validate() {
    RUST_TRIPLE="${1}-unknown-linux-gnu"
    FILENAME="rust-${VERSION}-${RUST_TRIPLE}"
    FETCHED_FILE="${FILENAME}.tar.xz"

    # Validate that the toolchain we downloaded matches the expected SHA256 checksum.
    test "${2}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
}

rm -rf ${BUILD}
mkdir -p ${BUILD}
cd ${BUILD}

for arg in "${@}"
do
    arch="$(echo "${arg}" | cut -d '=' -f 1)"
    shasum="$(echo "${arg}" | cut -d '=' -f 2)"
    validate "${arch}" "${shasum}" || (fetch "${arch}" && validate "${arch}" "${shasum}")
done