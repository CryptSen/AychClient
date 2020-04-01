FROM ubuntu:18.04 as builder
LABEL maintainer="core@aych.site"

ADD docker/Makefile /tmp/Makefile
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        automake \
        autotools-dev \
        binutils \
        bsdmainutils \
        build-essential \
        ca-certificates \
        git \
        libboost-all-dev \
        libevent-dev \
        libminiupnpc-dev \
        libprotobuf-dev \
        libssl-dev \
        libtool \
        pkg-config \
        wget && \
    cd /tmp && \
    make install && \
    strip /usr/local/bin/*aych*

FROM ubuntu:18.04

COPY --from=builder /usr/local/bin/*aych* /usr/local/bin/

RUN useradd -r -u 10000 dockeruser && \
    mkdir -p /opt/graphsense/data && \
    chown -R dockeruser /opt/graphsense && \
    # packages
    apt-get update && \
    apt-get install --no-install-recommends -y \
        libboost-chrono1.65.1 \
        libboost-filesystem1.65.1 \
        libboost-program-options1.65.1 \
        libboost-system1.65.1 \
        libboost-thread1.65.1 \
        libevent-2.1-6 \
        libevent-pthreads-2.1-6 \
        libminiupnpc10 \
        libssl1.1

ADD docker/aych.conf /opt/crytsen/aych.conf

USER dockeruser
EXPOSE 8532

CMD bash
CMD aychd -conf=/opt/cryptsen/aych.conf -datadir=/opt/cryptsen/data -daemon -rest && bash
