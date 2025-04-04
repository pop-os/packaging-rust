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