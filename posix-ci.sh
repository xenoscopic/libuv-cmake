#!/bin/sh

# Download libuv
git clone https://github.com/libuv/libuv.git || exit $?

# Checkout the appropriate version
cd libuv || exit $?
git checkout -q v${LIBUV_VERSION} || exit $?
cd .. || exit $?

# Copy CMakeLists.txt
cp CMakeLists.txt libuv || exit $?

# Create build directory and move there
mkdir build || exit $?
cd build || exit $?

# Run configuration
cmake ../libuv || exit $?

# Build
make || exit $?

# Test
./run-tests || exit $?

# All done
cd .. || exit $?
