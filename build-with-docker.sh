#!/bin/bash

docker run \
    -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):$(pwd) \
    -u $(id -u):$(id -g) \
    $(id -G | tr ' ' '\n' | xargs -I{} echo --group-add {}) \
    ghcr.io/webassembly/wasi-sdk:main \
    bash -c "cd $(pwd) && ./build.sh"
