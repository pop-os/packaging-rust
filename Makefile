ARCH     = $(shell uname -m)
VERSION  = 1.56.0
FILENAME = rust-$(VERSION)-$(ARCH)-unknown-linux-gnu
TARBALLS = upstream

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

mark-prebuild:
	touch debian/preparing