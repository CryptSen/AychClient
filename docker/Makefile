install:
	git clone https://github.com/cryptsen/aych.git src && \
	cd src && \
	git checkout tags/v0.17.1 -b local && \
	./autogen.sh && \
	./configure --without-gui --disable-upnp-default --disable-tests --disable-wallet; \
	make install
