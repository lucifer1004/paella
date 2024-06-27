#!/bin/bash

pixi install
git submodule update --init --recursive

# Link the stubbed libcuda.so
pushd .pixi/envs/default/targets/x86_64-linux/lib
ln -s stubs/libcuda.so libcuda.so
popd

# Initial build
cmake -S . -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=target \
    -DCMAKE_CUDA_ARCHITECTURES="80;90"
cmake --build build --target install

pushd tvm-llis
mkdir -p build
cp cmake/config.cmake build

# Build TVM
pushd build
cmake -G Ninja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../target
cmake --build . --target install
popd

# Install TVM's Python package
pushd python
pip install -v -e .
popd

popd

# Rebuild the project with the TVM dependency
pushd build
cmake .. -DTVM_DIR=$PWD/../tvm-llis/target
cmake --build . --target install
popd
