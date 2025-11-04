# syntax=docker/dockerfile:1
FROM debian:stable

ARG CPU_TYPE=z80
ARG SYNTAX_TYPE=oldstyle

RUN echo "deb [trusted=yes] http://archive.debian.org/debian buster main\n\
deb [trusted=yes] http://archive.debian.org/debian-security buster/updates main" > /etc/apt/sources.list

WORKDIR /usr/src

RUN set -eux; \
    apt-get update && \
    apt-get install -y \
        build-essential wget bsdmainutils z80dasm \
    && wget http://sun.hasenbraten.de/vasm/release/vasm.tar.gz \
    && tar xzf vasm.tar.gz \
    && cd vasm \
    && make CPU=${CPU_TYPE} SYNTAX=${SYNTAX_TYPE} \
    && cp vasm${CPU_TYPE}_${SYNTAX_TYPE} /usr/local/bin/vasm \
    && cp vobjdump /usr/local/bin/ \
    && rm -r /usr/src/vasm.tar.gz \
    && rm -r /usr/src/vasm/ \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

ENTRYPOINT [ "/bin/bash" ]