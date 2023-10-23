#!/bin/bash

SRC=$(dirname $0)

BUILD="$1"
LLVM_SRC="$2"

if [ "$LLVM_SRC" == "" ]; then
    LLVM_SRC=$(pwd)/upstream/llvm-project
fi

if [ "$BUILD" == "" ]; then
    BUILD=$(pwd)/build
fi

SRC=$(realpath "$SRC")
BUILD=$(realpath "$BUILD")
LLVM_BUILD=$BUILD/llvm
LLVM_NATIVE=$BUILD/llvm-native

CXXFLAGS="-Dwait4=__syscall_wait4" \
cmake --build \
    -S $LLVM_SRC/llvm/ \
    -B $LLVM_BUILD/ \
    -DCMAKE_TOOLCHAIN_FILE=/usr/share/cmake/wasi-sdk-pthread.cmake \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DLLVM_TARGETS_TO_BUILD=ARM \
    -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" \
    -DLLVM_ENABLE_DUMP=OFF \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    -DLLVM_ENABLE_EXPENSIVE_CHECKS=OFF \
    -DLLVM_ENABLE_BACKTRACES=OFF \
    -DLLVM_BUILD_TOOLS=OFF \
    -DLLVM_ENABLE_THREADS=OFF \
    -DLLVM_BUILD_LLVM_DYLIB=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN=$LLVM_NATIVE/bin/llvm-tblgen \
    -DCLANG_TABLEGEN=$LLVM_NATIVE/bin/clang-tblgen
