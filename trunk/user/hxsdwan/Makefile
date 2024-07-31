SRC_NAME=vpn
THISDIR = $(shell pwd)
download_test:
	( if [ ! -f $(SRC_NAME).tar.xz ]; then \
		wget -t5 --timeout=20 --no-check-certificate -O $(SRC_NAME).tar.xz $(SRC_URL); \
	fi )

extract_test:
	( if [ ! -d $(SRC_NAME) ]; then \
		tar xf $(SRC_NAME).tar.xz; \
		patch -d $(SRC_NAME) -p1 -i ../disable-doc-test.patch; \
	fi )

config_test:
	( if [ -f ./config_done ]; then \
		echo "the same configuration"; \
	else \
		make configure && touch config_done; \
	fi )

clean:

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/vpn.sh /usr/bin/vpn.sh
        $(ROMFSINST) $(THISDIR)/$(SRC_NAME)/vpn /usr/bin/vpn
