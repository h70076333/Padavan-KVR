THISDIR := $(shell pwd)
VPN_NAME := vnt

all: download_test extra_test
	@echo "vpn build done!"

download_test:
	( if [ ! -f $(VPN_NAME).tar.gz ]; then \
		wget -t5 --timeout=20 --no-check-certificate -O $(VPN_NAME).tar.gz ; \
	fi )

extra_test:
	( if [ ! -d $(VPN_NAME) ]; then \
		tar xf $(VPN_NAME).tar.gz; \
	fi )

clean:
	#rm -rf $(VPN_NAME).tar.gz $(VPN_NAME)

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/vpn.sh /usr/bin/vpn.sh
        $(ROMFSINST) $(THISDIR)/$(VPN_NAME)/vpn /usr/bin/vpn
