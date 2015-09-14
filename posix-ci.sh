#!/bin/sh

# Install a newer version of CMake if we're on Linux
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  sudo add-apt-repository --yes ppa:smspillaz/cmake-3.0.2 || exit $?
  sudo apt-get update -qq || exit $?
  sudo apt-get purge -qq cmake || exit $?
  sudo apt-get install cmake || exit $?
fi

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
cmake -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE} ../libuv || exit $?

# Build
cmake --build . || exit $?

# Test
# NOTE: Currently intentionally disabled, see note in README.md
# ./run-tests || exit $?

# All done
cd .. || exit $?
