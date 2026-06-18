# Pinned by digest for reproducibility (debian:bookworm-slim at time of pinning).
# Note: apt-get below still pulls current bookworm packages, so the build is
# reproducible for the base layer and the SHA256-pinned mtasc/swfmill/font, but
# not bit-for-bit across apt updates. Re-pin the digest when bumping the base.
FROM --platform=linux/amd64 debian:bookworm-slim@sha256:96e378d7e6531ac9a15ad505478fcc2e69f371b10f5cdf87857c4b8188404716

ARG MTASC_DEB_URL=https://snapshot.debian.org/archive/debian/20130611T160143Z/pool/main/m/mtasc/mtasc_1.14-3_amd64.deb
ARG MTASC_DEB_SHA256=86210e92dd51790c910b36d52f5075e35624833963a91f82deb9d83d3be4d782
ARG SWFMILL_DEB_URL=https://snapshot.debian.org/archive/debian/20190807T225524Z/pool/main/s/swfmill/swfmill_0.3.6-1%2Bb1_amd64.deb
ARG SWFMILL_DEB_SHA256=f42afba04e89158ed1a81e4234374bf4444abc8c40013cac20b8a25a571ca46e

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libfreetype6 \
        libpng16-16 \
        libxml2 \
        libxslt1.1 \
        make \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "$MTASC_DEB_URL" -o /tmp/mtasc.deb \
    && echo "$MTASC_DEB_SHA256  /tmp/mtasc.deb" | sha256sum -c - \
    && dpkg -i /tmp/mtasc.deb \
    && rm -f /tmp/mtasc.deb \
    && test -x /usr/bin/mtasc \
    && test -d /usr/share/mtasc/std \
    && test -d /usr/share/mtasc/std8

RUN curl -fsSL "$SWFMILL_DEB_URL" -o /tmp/swfmill.deb \
    && echo "$SWFMILL_DEB_SHA256  /tmp/swfmill.deb" | sha256sum -c - \
    && dpkg -i /tmp/swfmill.deb \
    && rm -f /tmp/swfmill.deb \
    && test -x /usr/bin/swfmill

WORKDIR /work
