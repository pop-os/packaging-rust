rootdir := ''
arch := `uname -m`
version := 'unset'
target := arch + '-unknown-linux-gnu'
filename := 'rust-' + version + '-' + target
tarballs := 'upstream'
compressed := tarballs + '/' + filename + '.tar.gz'

all:
	tar -xf {{compressed}}

distclean:
	rm -rf {{tarballs}} rust-*

install:
	#!/bin/sh
	sh {{filename}}/install.sh --destdir={{rootdir}} --prefix=/usr
	rm {{rootdir}}/usr/lib/rustlib/uninstall.sh
	if test "{{arch}}" = "aarch64"; then
		rm -f "{{rootdir}}/usr/lib/rustlib/{{target}}/bin/rust-llvm-dwp"
	fi

fetch sum_x86_64 sum_aarch64:
	#!/bin/bash
	function fetch () {
		echo fetching ${1}
		RUST_TRIPLE="${1}-unknown-linux-gnu"
		FILENAME="rust-{{version}}-${RUST_TRIPLE}"
		FETCHED_FILE="{{tarballs}}/${FILENAME}.tar.gz"

		curl --create-dirs -O "https://static.rust-lang.org/dist/${FILENAME}.tar.gz"
	}

	function validate() {
		echo validating ${1}
		RUST_TRIPLE="${1}-unknown-linux-gnu"
		FILENAME="rust-{{version}}-${RUST_TRIPLE}"
		FETCHED_FILE="${FILENAME}.tar.gz"

		# Validate that the toolchain we downloaded matches the expected SHA256 checksum.
		SUM="$(sha256sum ${FETCHED_FILE} | cut -d' ' -f1)"

		case "${1}" in
			"x86_64")
				test "{{sum_x86_64}}" = "${SUM}"
				;;
			"aarch64")
				test "{{sum_aarch64}}" = "${SUM}"
				;;
			*)
				echo "Unsupported architecture: ${1}"
				return 1
				;;
		esac
	}

	mkdir -p {{tarballs}}
	cd {{tarballs}}

	function fetch_target() {
		validate ${1} || (fetch ${1} && validate ${1})
	}

	fetch_target x86_64
	fetch_target aarch64
