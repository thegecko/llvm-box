FROM ghcr.io/webassembly/wasi-sdk:main as wasi

FROM ubuntu:jammy

ENV LLVM_VERSION 17

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
        gnupg \
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
        zlib1g-dev && \
\
    curl -sS https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/llvm.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/llvm.gpg] http://apt.llvm.org/jammy/ llvm-toolchain-jammy-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src [signed-by=/etc/apt/trusted.gpg.d/llvm.gpg] http://apt.llvm.org/jammy/ llvm-toolchain-jammy-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm.list && \
\
    apt-get update && \
    apt-get install -y clang-${LLVM_VERSION} lld-${LLVM_VERSION} cmake ninja-build make autoconf autogen automake libtool && \
    apt-get remove -y curl gnupg && \
    rm -rf /var/lib/apt/lists/*

COPY --from=wasi /wasi-sysroot/ /wasi-sysroot/
COPY --from=wasi /usr/lib/llvm-${LLVM_VERSION}/lib/clang/${LLVM_VERSION}/lib/wasi /usr/lib/llvm-${LLVM_VERSION}/lib/clang/${LLVM_VERSION}/lib/wasi

COPY --from=wasi /usr/share/cmake/wasi-sdk.cmake /usr/share/cmake/wasi-sdk.cmake
COPY --from=wasi /usr/share/cmake/wasi-sdk-pthread.cmake /usr/share/cmake/wasi-sdk-pthread.cmake
COPY --from=wasi /usr/share/cmake/Modules/Platform/WASI.cmake /usr/share/cmake/Modules/Platform/WASI.cmake

ENV CMAKE_TOOLCHAIN_FILE /usr/share/cmake/wasi-sdk.cmake

ENV CC clang-${LLVM_VERSION}
ENV CXX clang++-${LLVM_VERSION}
ENV LD wasm-ld-${LLVM_VERSION}
ENV AR llvm-ar-${LLVM_VERSION}
ENV RANLIB llvm-ranlib-${LLVM_VERSION}

ENV CFLAGS --target=wasm32-wasi --sysroot=/wasi-sysroot
ENV CXXFLAGS --target=wasm32-wasi --sysroot=/wasi-sysroot
ENV LDFLAGS --target=wasm32-wasi --sysroot=/wasi-sysroot

# ------------------------------------------------------------------------------
# Use commonly used /src as working directory
WORKDIR /src
