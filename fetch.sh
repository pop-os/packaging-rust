#!/bin/bash

set -ex

SHASUM_x86_64=5189cd56447f9d56fcd7a1966efe5a8efd19843fdfd6bf9a23a9acbc57b5e3f9
SHASUM_AARCH64=f3e9a9c8af7d17a2fbe0ce561a7dc42f65c5444025783f1f63cd47960a534a9e

TARGET="$1"
FILENAME="$2"
ARCH="$3"

FETCHED_FILE="${TARGET}/${FILENAME}.tar.gz"

mkdir -p ${TARGET}

cd ${TARGET}

curl --create-dirs -O "https://static.rust-lang.org/dist/${FILENAME}.tar.gz"

cd ..

function validate () {
    # Validate that the toolchain we downloaded matches the expected SHA256 checksum.
    if test "x86_64" = "${ARCH}"; then
        test "${SHASUM_x86_64}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
    elif test "aarch64" = "${ARCH}"; then
        test "${SHASUM_AARCH64}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
    else
        return 1
    fi
}

if validate; then
    echo "Sucessfully fetched"
    exit 0
fi

echo "Failed to fetch Rust"
rm ${FETCHED_FILE}
exit 1