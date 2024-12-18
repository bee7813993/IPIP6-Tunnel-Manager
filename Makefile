PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
DISPATCHERDIR = /etc/networkd-dispatcher/routable.d
CONFDIR = /etc
NETPLANDIR = /etc

install:
	mkdir -p $(BINDIR) $(LIBDIR) $(DISPATCHERDIR) $(CONFDIR)
	sed "s|@PREFIX@|$(PREFIX)|g" bin/setup-ipip6.sh > $(BINDIR)/setup-ipip6.sh
	chmod 755 $(BINDIR)/setup-ipip6.sh
	sed "s|@PREFIX@|$(PREFIX)|g" bin/cleanup-ipip6.sh > $(BINDIR)/cleanup-ipip6.sh
	chmod 755 $(BINDIR)/cleanup-ipip6.sh
	sed "s|@PREFIX@|$(PREFIX)|g" lib/ipip6-utils.sh > $(LIBDIR)/ipip6-utils.sh
	chmod 644 $(LIBDIR)/ipip6-utils.sh
	sed "s|@PREFIX@|$(PREFIX)|g" dispatcher/50-ipip6-handler > $(DISPATCHERDIR)/50-ipip6-handler
	chmod 755 $(DISPATCHERDIR)/50-ipip6-handler
	install -m 644 etc/ipip6.conf $(CONFDIR)/ipip6.conf
	install -m 644 etc/netplan-template.yaml $(NETPLANDIR)/netplan-template.yaml

uninstall:
	rm -f $(BINDIR)/setup-ipip6.sh
	rm -f $(BINDIR)/cleanup-ipip6.sh
	rm -f $(LIBDIR)/ipip6-utils.sh
	rm -f $(DISPATCHERDIR)/50-ipip6-handler
	rm -f $(CONFDIR)/ipip6.conf
	rm -f $(NETPLANDIR)/netplan-template.yaml

.PHONY: install uninstall
