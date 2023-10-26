#!/bin/bash

# https://github.com/jprendes/emception/blob/f6aa9eb24f69f46b7f3dcd58adad6cdf7e412d16/build-llvm.sh
# MIT Licence, File has been modified.

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
LLVM_NATIVE=$BUILD/llvm-native

# If we don't have a copy of LLVM, make one
if [ ! -d $LLVM_SRC/ ]; then
    git clone --depth 1 https://github.com/thegecko/llvm-project.git "$LLVM_SRC/"

    pushd $LLVM_SRC/
    
    # This is the last tested commit of llvm-project.
    # Feel free to try with a newer version
    #COMMIT=d5a963ab8b40fcf7a99acd834e5f10a1a30cc2e5
    COMMIT=bfb079f2d811626009f1a67415a02b4255f52f51
    git reset --hard $COMMIT
    git fetch origin $COMMIT

    # The clang driver will sometimes spawn a new process to avoid memory leaks.
    # Since this complicates matters quite a lot for us, just disable that.
    #git apply $SRC/patches/llvm-project.patch

    popd
fi

# Cross compiling llvm needs a native build of "llvm-tblgen" and "clang-tblgen"
if [ ! -d $LLVM_NATIVE/ ]; then
    cmake -G Ninja \
        -S $LLVM_SRC/llvm/ \
        -B $LLVM_NATIVE/ \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=ARM \
        -DLLVM_ENABLE_PROJECTS="clang"
fi
cmake --build $LLVM_NATIVE/ -- llvm-tblgen clang-tblgen
