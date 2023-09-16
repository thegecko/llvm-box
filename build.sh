#!/bin/bash

SRC=$(dirname $0)
BUILD="$1"

if [ "$BUILD" == "" ]; then
    BUILD=$(pwd)/build
fi

SRC=$(realpath "$SRC")
BUILD=$(realpath "$BUILD")

$SRC/build-tooling.sh "$BUILD"
$SRC/build-llvm.sh "$BUILD" "$LLVM_SRC"
