#!/bin/bash

SRC=$(pwd)/llvm-project/llvm/
OUTPUT=$(pwd)/build/llvm-native/

# Cross compiling llvm needs a native build of "llvm-tblgen" and "clang-tblgen"
if [ ! -d $OUTPUT ]; then
    cmake -G Ninja \
        -S $SRC \
        -B $OUTPUT \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=ARM \
        -DLLVM_ENABLE_PROJECTS="clang"
fi
cmake --build $OUTPUT -- llvm-tblgen clang-tblgen
