FROM ubuntu:jammy

RUN echo "## Update and install packages" \
    && apt-get -qq -y update \
    # Somewhere in here apt sets up tzdata which asks for your time zone and blocks
    # waiting for the answer which you can't give as docker build doesn't read from
    # the terninal. The env vars set here avoid the interactive prompt and set the TZ.
    && DEBIAN_FRONTEND="noninteractive" TZ="America/San_Francisco" apt-get -qq install -y --no-install-recommends \
        sudo \
        libxml2 \
        ca-certificates \
        python3 \
        python3-pip \
        wget \
        curl \
        zip \
        unzip \
        git \
        git-lfs \
        ssh-client \
        build-essential \
        make \
        ant \
        libidn12 \
        cmake \
        openjdk-11-jre-headless \
        docker.io \
        pkg-config \
        ninja-build \
        jq \
        autoconf \
        autoconf-archive \
        automake \
        zlib1g-dev \
    # Standard Cleanup on Debian images
    && apt-get -y clean \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/debconf/*-old \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/?? \
    && rm -rf /usr/share/man/??_* \
    && echo "## Done"

# ------------------------------------------------------------------------------
# Use commonly used /src as working directory
WORKDIR /src
