#!/bin/bash

set -ex

SHASUM_x86_64=a6be5d045183a0b12dddf0d81633e2a64e63e4c2dfa44eb7593970c1ef93a98f
SHASUM_AARCH64=69792887357c8dd78c5424f0b4a624578296796d99edf6c30ebe2acc2b939aa3

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