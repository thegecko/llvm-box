#!/bin/bash

SRC=$(pwd)/llvm-project/llvm/
OUTPUT=$(pwd)/build/llvm-wasi/
NATIVE_TOOLS=$(pwd)/build/llvm-native/bin

# Configure the main build, main point here is that the compiler targets the ARM platform,
# Including ARM Embedded devices.
if [ ! -d $OUTPUT ]; then
    cmake -G Ninja \
        -S $SRC \
        -B $OUTPUT \
        -DLLVM_NATIVE_TOOL_DIR=$NATIVE_TOOLS \
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
        -DLLVM_INCLUDE_UTILS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_BENCHMARKS=OFF \
        -DLLVM_INCLUDE_GO_TESTS=OFF \
        -DLLVM_ENABLE_BINDINGS=OFF \
        -DLLVM_ENABLE_UNWIND_TABLES=OFF \
        -DLLVM_ENABLE_CRASH_OVERRIDES=OFF \
        -DLLVM_ENABLE_TERMINFO=OFF \
        -DLLVM_ENABLE_LIBXML2=OFF \
        -DLLVM_ENABLE_LIBEDIT=OFF \
        -DLLVM_ENABLE_LIBPFM=OFF \
        -DLLVM_ENABLE_ZLIB=OFF \
        -DLLVM_BUILD_DOCS=OFF \
        -DLLVM_ENABLE_OCAMLDOC=OFF \
        -DLLVM_ENABLE_PIC=OFF \
        -DLLVM_BUILD_STATIC=ON \
        -DCMAKE_SKIP_INSTALL_RPATH=ON \
        -DCMAKE_SKIP_RPATH=ON \
        -DCLANG_ENABLE_ARCMT=OFF \
        -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
        -DCLANG_BUILD_TOOLS=OFF \
        -DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake
fi
cmake --build $OUTPUT -- clang lld
