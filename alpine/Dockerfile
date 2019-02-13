FROM alpine:3.8

# Install required packages
RUN apk add --no-cache \
    # development packages to be removed after build
    tar \
    autoconf \
    automake \
    libcurl \
    jansson-dev \
    make \
    gcc \
    g++ \
    util-linux-dev \
    # runtime libraries
    libuuid \
    libconfig \
    gnutls-dev \
    gnutls \
    jansson \
    libgcrypt \
    libmicrohttpd \
    sqlite-libs \
    sqlite \
    mariadb-connector-c \
    mariadb-connector-c-dev \
    libtool \
    libldap \
    wget \
    cmake \
    openssl \
    bash

ARG GLEWLWYD_VERSION=1.4.9
ARG LIBJWT_VERSION=1.9.0

ENV DB_INIT_FILE=init-sqlite3-sha256.sql
ENV ADMIN_EMAIL=root@kuhn.host

# libtool and autoconf may be required, install them with 'sudo apt-get install libtool autoconf'
RUN mkdir /opt && \
    cd /opt && \
    wget https://github.com/benmcollins/libjwt/archive/v${LIBJWT_VERSION}.tar.gz && \
    tar -zxvf v${LIBJWT_VERSION}.tar.gz && \
    rm v${LIBJWT_VERSION}.tar.gz && \
    cd libjwt-${LIBJWT_VERSION}/ && \
    autoreconf -i && \
    ./configure --without-openssl && \
    make && \
    make install && \
# Download and install Glewlwyd package
    mkdir /build && \
    cd /build && \
    wget https://github.com/babelouest/glewlwyd/releases/download/v${GLEWLWYD_VERSION}/glewlwyd-full_${GLEWLWYD_VERSION}_alpine_3.8.1_x86_64.tar.gz && \
    tar -xf glewlwyd-full_${GLEWLWYD_VERSION}_alpine_3.8.1_x86_64.tar.gz && \
    tar xf liborcania_*.tar.gz && \
    mv liborcania_*/lib64/*.so* /usr/lib && \
    tar xf libyder_*.tar.gz && \
    mv libyder_*/lib64/*.so* /usr/lib && \
    tar xf libulfius_*.tar.gz && \
    mv libulfius_*/lib64/*.so* /usr/lib && \
    tar xf libhoel_*.tar.gz && \
    mv libhoel_*/lib64/*.so* /usr/lib && \
    tar xf glewlwyd_*.tar.gz && \
    rm -rf *.tar.gz && \
    mkdir -p /usr/share/glewlwyd/ && \
    cp -R glewlwyd_*/share/glewlwyd/webapp/ /usr/share/glewlwyd/ && \
    cp -R ./glewlwyd_*/bin/* /usr/bin && \
    cp -R ./glewlwyd_*/etc/* /etc && \
    mkdir /usr/share/init-db  && \
    mv ./glewlwyd_*/share/doc/glewlwyd/database /usr/share/init-db && \
    cd / && \
    rm -rf /build && \
    apk del \
    tar \
    autoconf \
    automake \
    libcurl \
    jansson-dev \
    make \
    gcc \
    g++ \
    util-linux-dev

COPY ["entrypoint.sh", "/"]

EXPOSE 4593
RUN mkdir /var/cache/glewlwyd/
CMD ["/entrypoint.sh"]
