ARCH        = $(shell uname -m)
VERSION     = 1.56.0
RUST_TRIPLE = $(ARCH)-unknown-linux-gnu
FILENAME    = rust-$(VERSION)-$(RUST_TRIPLE)
TARBALLS    = upstream

all: $(FILENAME)

$(FILENAME):
	tar -xf $(TARBALLS)/$(FILENAME).tar.gz

clean: preclean $(TARBALLS)/$(FILENAME).tar.gz
	rm -rf $(FILENAME)

preclean:
	if test -e debian/preparing; then rm -rf upstream debian/preparing; fi

$(TARBALLS)/$(FILENAME).tar.gz:
	bash fetch.sh $(TARBALLS) $(FILENAME) $(ARCH)

install:
	sh $(FILENAME)/install.sh --destdir=$(DESTDIR) --prefix=/usr
	rm $(DESTDIR)/usr/lib/rustlib/uninstall.sh
	if test "$(ARCH)" = "aarch64"; then \
		rm -f "$(DESTDIR)/usr/lib/rustlib/$(RUST_TRIPLE)/bin/rust-llvm-dwp"; \
	fi

mark-prebuild:
	touch debian/preparing