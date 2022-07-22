rootdir := ''
arch := `uname -m`
version := '1.7.3'
target := 'julia-' + version
filename := 'julia-' + version + '-linux-' + arch
tarballs := 'upstream'
compressed := tarballs + '/' + filename + '.tar.gz'

all:
	tar -xf {{compressed}}

distclean:
	rm -rf {{filename}} upstream julia-*

install:
  mkdir -p {{rootdir}}/usr
  cp ./{{target}}/* {{rootdir}}/usr -r
