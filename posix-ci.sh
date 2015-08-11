#!/bin/sh

# Download libuv
wget https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz -O libuv-${LIBUV_VERSION}.tar.gz || exit $?

# Unzip
tar xzf libuv-${LIBUV_VERSION}.tar.gz || exit $?

# Copy CMakeLists.txt
cp CMakeLists.txt libuv-${LIBUV_VERSION} || exit $?

# Create build directory and move there
mkdir libuv-${LIBUV_VERSION}/build || exit $?
cd libuv-${LIBUV_VERSION}/build || exit $?

# Run configuration
cmake .. || exit $?

# Build
make || exit $?

# Test
./run-tests || exit $?
