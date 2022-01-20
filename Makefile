ARCH        = $(shell uname -m)
VERSION     = 1.58.1
RUST_TRIPLE = $(ARCH)-unknown-linux-gnu
FILENAME    = rust-$(VERSION)-$(RUST_TRIPLE)
COMPRESSED  = $(TARBALLS)/$(FILENAME).tar.gz
TARBALLS    = upstream

all: $(FILENAME)

$(FILENAME):
	tar -xf $(COMPRESSED)

clean:
	rm -rf $(FILENAME)

distclean:
	rm -rf $(FILENAME) upstream rust-*

vendor: $(COMPRESSED)

$(COMPRESSED):
	bash fetch.sh $(TARBALLS) $(VERSION)

install:
	sh $(FILENAME)/install.sh --destdir=$(DESTDIR) --prefix=/usr
	rm $(DESTDIR)/usr/lib/rustlib/uninstall.sh
	if test "$(ARCH)" = "aarch64"; then \
		rm -f "$(DESTDIR)/usr/lib/rustlib/$(RUST_TRIPLE)/bin/rust-llvm-dwp"; \
	fi
