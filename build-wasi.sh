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

# Configure the main build, main point here is that the compiler targets the ARM platform,
# Including ARM Embedded devices.
if [ ! -d $LLVM_BUILD/ ]; then
    CXXFLAGS="-Dwait4=__syscall_wait4" \
    LDFLAGS="\
        -s LLD_REPORT_UNDEFINED=1 \
        -s ALLOW_MEMORY_GROWTH=1 \
        -s EXPORTED_FUNCTIONS=_main,_free,_malloc \
        -s EXPORTED_RUNTIME_METHODS=FS,PROXYFS,ERRNO_CODES,allocateUTF8 \
        -lproxyfs.js \
    " cmake -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
        -S $LLVM_SRC/llvm/ \
        -B $LLVM_BUILD/ \
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

    # Make sure we build js modules (.mjs).
    # The patch-ninja.sh script assumes that.
    sed -i -E 's/\.js/.mjs/g' $LLVM_BUILD/build.ninja

    # The mjs patching is over zealous, and patches some source JS files rather than just output files.
    # Undo that.
    sed -i -E 's/(pre|post|proxyfs|fsroot)\.mjs/\1.js/g' $LLVM_BUILD/build.ninja

    # Patch the build script to add the "llvm-box" target.
    # This new target bundles many executables in one, reducing the total size.
    pushd $SRC
    TMP_FILE=$(mktemp)
    ./patch-ninja.sh \
        $LLVM_BUILD/build.ninja \
        llvm-box \
        $BUILD/tooling \
        clang lld llvm-objcopy \
        > $TMP_FILE
    cat $TMP_FILE >> $LLVM_BUILD/build.ninja
    popd
fi
cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} --build $LLVM_BUILD/ -- llvm-box
