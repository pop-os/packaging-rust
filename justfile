rootdir := ''
arch := `uname -m`
version := '1.62.0'
target := arch + '-unknown-linux-gnu'
filename := 'rust-' + version + '-' + target
tarballs := 'upstream'
compressed := tarballs + '/' + filename + '.tar.gz'

all:
	tar -xf {{compressed}}

distclean:
	rm -rf {{filename}} upstream rust-*

install:
	sh {{filename}}/install.sh --destdir={{rootdir}} --prefix=/usr
	rm {{rootdir}}/usr/lib/rustlib/uninstall.sh
	if test "{{arch}}" = "aarch64"; then \
		rm -f "{{rootdir}}/usr/lib/rustlib/{{target}}/bin/rust-llvm-dwp"; \
	fi
