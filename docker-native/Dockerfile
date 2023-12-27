FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends -qy update && \
    DEBIAN_FRONTEND=noninteractive apt --no-install-recommends -qy install \
    build-essential \
    python3 \
    cmake \
    ninja-build
