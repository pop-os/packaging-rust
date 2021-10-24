ARCH           = $(shell uname -m)
VERSION        = 1.56.0
FILENAME       = rust-$(VERSION)-$(ARCH)-unknown-linux-gnu
SHASUM_x86_64  = 5189cd56447f9d56fcd7a1966efe5a8efd19843fdfd6bf9a23a9acbc57b5e3f9
SHASUM_AARCH64 = f3e9a9c8af7d17a2fbe0ce561a7dc42f65c5444025783f1f63cd47960a534a9e

all: $(FILENAME)

$(FILENAME):
	tar -xf upstream/$(FILENAME).tar.gz

clean:
	rm -rf $(FILENAME)

distclean:
	rm -rf $(FILENAME) upstream

fetch:
	# Download the toolchain from rust-lang.org
	curl --create-dirs -O --output-dir upstream \
		https://static.rust-lang.org/dist/$(FILENAME).tar.gz
	# Validate that the toolchain we downloaded matches the expected SHA256 checksum.
	if test "x86_64" = "$(ARCH)"; then \
		test "$(SHASUM_x86_64)" = "$$(sha256sum upstream/$(FILENAME).tar.gz | cut -d' ' -f1)"; \
	elif test "AARCH64" = "$(ARCH)"; then \
		test "$(SHASUM_AARCH64)" = "$$(sha256sum upstream/$(FILENAME).tar.gz | cut -d' ' -f1)"; \
	else \
		echo no match; \
		exit 1; \
	fi

install:
	sh $(FILENAME)/install.sh --destdir=$(DESTDIR) --prefix=/usr
	rm $(DESTDIR)/usr/lib/rustlib/uninstall.sh
