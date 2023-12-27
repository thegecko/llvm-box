include(/usr/share/cmake/wasi-sdk.cmake)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_WASI_EMULATED_SIGNAL -no-pthread")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Dwait4=__syscall_wait4 -D_WASI_EMULATED_SIGNAL -no-pthread")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lwasi-emulated-signal")
