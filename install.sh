#!/bin/bash

git submodule update --init --recursive

cmake -S . -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=target \
    -DCMAKE_CUDA_ARCHITECTURES="80;90"
cmake --build build --target install

pushd tvm-llis
mkdir -p build
cp cmake/config.cmake build
pushd build
cmake -G Ninja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../target
cmake --build . --target install
popd
popd

pushd build
cmake .. -DTVM_DIR=/home/zihuaw/com.github/eniac/paella/tvm-llis/target
cmake --build . --target install
popd
