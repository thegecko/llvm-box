#!/bin/bash

# https://github.com/jprendes/emception/blob/f6aa9eb24f69f46b7f3dcd58adad6cdf7e412d16/build-tooling.sh
# MIT License, modified to remove wasm-package.

SRC=$(dirname $0)
BUILD="$1"

if [ "$BUILD" == "" ]; then
    BUILD=$(pwd)/build
fi

SRC=$(realpath "$SRC")
BUILD=$(realpath "$BUILD")

TOOLING_BUILD=$BUILD/tooling

mkdir -p $TOOLING_BUILD

$SRC/tooling/wasm-transform/compile.sh $TOOLING_BUILD
cp $SRC/tooling/wasm-transform/{codegen.sh,merge_codegen.sh,wasm-transform.sh} $TOOLING_BUILD