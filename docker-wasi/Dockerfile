FROM ghcr.io/webassembly/wasi-sdk:main

RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends -qy update && \
    DEBIAN_FRONTEND=noninteractive apt --no-install-recommends -qy install \
    docker.io \
    pkg-config \
    ninja-build \
    jq \
    autoconf \
    autoconf-archive \
    automake \
    zlib1g-dev
