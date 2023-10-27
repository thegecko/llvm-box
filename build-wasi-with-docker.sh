#!/bin/bash

SRC=$(dirname $0)

pushd $SRC/docker-wasi
docker build \
    -t wasi_build \
    .
popd

docker run \
    -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):$(pwd) \
    -u $(id -u):$(id -g) \
    $(id -G | tr ' ' '\n' | xargs -I{} echo --group-add {}) \
    wasi_build:latest \
    bash -c "cd $(pwd) && ./build-wasi.sh"