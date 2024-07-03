rootdir := ''
arch := `uname -m`
version := 'unset'
target := arch + '-unknown-linux-gnu'
filename := 'rust-' + version + '-' + target
tarballs := 'upstream'
compressed := tarballs + '/' + filename + '.tar.xz'

all:
	tar -xf {{compressed}}

distclean:
	rm -rf {{tarballs}} rust-*

install:
	#!/bin/sh
	sh {{filename}}/install.sh --destdir={{rootdir}} --prefix=/usr --verbose
	rm {{rootdir}}/usr/lib/rustlib/uninstall.sh
	if test "{{arch}}" = "aarch64"; then
		rm -f "{{rootdir}}/usr/lib/rustlib/{{target}}/bin/rust-llvm-dwp"
	fi

download target version shasum_x86_64 shasum_aarch64:
	#!/bin/bash
	set -e

	function fetch () {
		RUST_TRIPLE="${1}-unknown-linux-gnu"
		FILENAME="rust-{{version}}-${RUST_TRIPLE}"
		FETCHED_FILE="{{target}}/${FILENAME}.tar.xz"

		curl --create-dirs -O "https://static.rust-lang.org/dist/${FILENAME}.tar.xz"
	}

	function validate() {
		RUST_TRIPLE="${1}-unknown-linux-gnu"
		FILENAME="rust-{{version}}-${RUST_TRIPLE}"
		FETCHED_FILE="${FILENAME}.tar.xz"

		# Validate that the toolchain we downloaded matches the expected SHA256 checksum.
		if test "x86_64" = "${1}"; then
			test "{{shasum_x86_64}}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
		elif test "aarch64" = "${1}"; then
			test "{{shasum_aarch64}}" = "$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"
		else
			return 1
		fi
	}

	rm -rf {{target}}
	mkdir -p {{target}}
	cd {{target}}

	function fetch_target() {
		validate ${1} || (fetch ${1} && validate ${1})
	}

	fetch_target x86_64
	fetch_target aarch64
