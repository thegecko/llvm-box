#!/bin/bash
set -e

SRC=$(dirname $0)

pushd $SRC/docker-native
docker build \
    -t llvm_native \
    .
popd

docker run \
    -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):$(pwd) \
    -u $(id -u):$(id -g) \
    $(id -G | tr ' ' '\n' | xargs -I{} echo --group-add {}) \
    llvm_native:latest \
    bash -c "cd $(pwd) && ./build-tblgen.sh"

docker run \
    -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):$(pwd) \
    -u $(id -u):$(id -g) \
    $(id -G | tr ' ' '\n' | xargs -I{} echo --group-add {}) \
    ghcr.io/webassembly/wasi-sdk:main \
    bash -c "cd $(pwd) && ./build-wasi.sh"
