#!/bin/bash

SRC=$(pwd)/llvm-project/llvm/
OUTPUT=$(pwd)/build/llvm-wasi/
TBLGEN_BINARY=$(pwd)/build/llvm-native/bin

# Configure the main build, main point here is that the compiler targets the ARM platform,
# Including ARM Embedded devices.
if [ ! -d $OUTPUT ]; then
    cmake -G Ninja \
        -S $SRC \
        -B $OUTPUT \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DUNIX=True \
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
        -DLLVM_TABLEGEN=$TBLGEN_BINARY/llvm-tblgen \
        -DCLANG_TABLEGEN=$TBLGEN_BINARY/clang-tblgen \
        -DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake
fi
cmake --build $OUTPUT -- clang lld
