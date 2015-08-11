# libuv-cmake

CMake utilities for building and finding libuv.


## Motivation

libuv is awesome, but only comes with two build systems: Autotools (which isn't
robustly cross-platform) and GYP (which is a tangled mess of inconsistent code
and configuration that even Google is
[jumping ship](http://permalink.gmane.org/gmane.comp.web.blink.devel/11098) on).
Neither of these is good for integrating into a larger project, but CMake is
perfect for this sort of thing.

## Status

The module is currently tested<sup>1</sup> on the following platforms:

| [Windows][win-link] | [OS X][osx-link] | [Linux][lin-link] |
| :-----------------: | :--------------: | :---------------: |
| ![win-badge]        | ![osx-badge]     | ![lin-badge]      |

[win-badge]: https://ci.appveyor.com/api/projects/status/1v265vkb5edd2r75/branch/master?svg=true "AppVeyor build status"
[win-link]:  https://ci.appveyor.com/project/havoc-io/libuv-cmake/branch/master "AppVeyor build status"
[osx-badge]: https://travis-ci.org/havoc-io/libuv-cmake.svg?branch=master "Travis CI build status"
[osx-link]:  https://travis-ci.org/havoc-io/libuv-cmake "Travis CI build status"
[lin-badge]: https://circleci.com/gh/havoc-io/libuv-cmake/tree/master.svg?style=shield "CircleCI build status"
[lin-link]:  https://ci.appveyor.com/project/havoc-io/libuv-cmake "CircleCI build status"

<sup>
1: Sadly, the libuv tests do not behave well on CI, partly because of
restrictions on binding to sockets and partly because of several race conditions
which seem to exist in the test themselves.  I think this is why libuv doesn't
use CI testing.  Consequently, the tests are currently *built* on CI, but not
run.  If you want to execute the tests, you'll have to build locally :cry:.
</sup>

Other platforms are not tested, but are supported!  If you can test on any of
the following platforms and report your results, it would be much appreciated:

- DragonFly BSD
- FreeBSD
- NetBSD
- OpenBSD
- AIX
- SunOS
- Android


## Requirements

- CMake 2.8.12+


## Components

There are two components to libuv-cmake:

- **CMakeLists.txt**: This will build libuv and its associated tests, and
  optionally install the library.  It is based off of the libuv Autotools build
  system, but updated to use CMake paradigms.
- **Findlibuv.cmake**: This module will locate libuv so that you're project can
  link against it, even if your version of libuv wasn't built with libuv-cmake.
  This is much less finicky and more cross-platform than messing with
  pkg-config.  Alternatively, you can simply include libuv in your build tree
  (with `CMakeLists.txt` copied inside it) and use `ADD_SUBDIRECTORY` to
  incorporate the CMake build.


## Usage

The components of libuv-cmake can be used individually or together.
`Findlibuv.cmake` will even find a libuv installed with Autotools!


### **CMakeLists.txt**

To use `CMakeLists.txt`, simply plop it into your libuv source tree and build it
like any other projects.  libuv-cmake is tagged to match libuv releases, so you
can download the appropriate `CMakeLists.txt` for your libuv version.  E.g., the
`CMakeLists.txt` corresponding to libuv 1.7.0 can be found at:

[https://raw.githubusercontent.com/havoc-io/libuv-cmake/1.7.0/CMakeLists.txt](https://raw.githubusercontent.com/havoc-io/libuv-cmake/1.7.0/CMakeLists.txt)

You can find a full list of releases
[here](https://github.com/havoc-io/libuv-cmake/releases).

After compilation, tests (if enabled), can be run via CTest, e.g.

    make test # Adjust for your generator

although this masks all the fun output, so it's better to just execute the test
binary directly:

    ./run-tests

This build system also adds a few nice features, which can be enabled/disabled
at configuration time:

- **BUILD_SHARED_LIBS**: Whether to build libuv as a shared library (`ON` by
  default) or a static library (`OFF`)
- **BUILD_TESTS**: Whether or not to build libuv tests (`ON` by default)
- **BIN_INSTALL_DIR**: The subdirectory of `CMAKE_INSTALL_PREFIX` which will be
  used to install runtime binaries (`bin` by default) (note that, on Windows,
  CMake considers `.dll` files to be runtime binaries, and will stick them in
  the binary install directory, while the corresponding export `.lib` files will
  be stuck in the library install directory)
- **LIB_INSTALL_DIR**: The subdirectory of `CMAKE_INSTALL_PREFIX` which will be
  used to install libraries (`lib` by default)
- **INCLUDE_INSTALL_DIR**: The subdirectory of `CMAKE_INSTALL_PREFIX` which will
  be used to install include headers (`include` by default)
- **ENABLE_SOVERSION**: Whether or not to enable shared library name versioning,
  e.g. `libfoo.1.2.3.so` (only applies on systems which support this) (`OFF` by
  default)


### **Findlibuv.cmake**

To use `Findlibuv.cmake`, you simply need to include it in your
`CMAKE_MODULE_PATH`, e.g. by putting it in a subdirectory of your project called
`cmake` and then doing:

    LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_PROJECT_DIR}/cmake")

You can then find libuv by doing:

    FIND(libuv)

or, if you want to ensure libuv is found before proceeding:

    FIND(libuv REQUIRED)

The module follows standard CMake conventions.  The variable `LIBUV_FOUND` will
be set `TRUE` if libuv was located, `FALSE` otherwise.  If libuv is found, the
variables `LIBUV_INCLUDE_DIRS` and `LIBUV_LIBRARIES` will be populated, at which
point you can do something like:

    TARGET_INCLUDE_DIRECTORIES(MyTarget PRIVATE ${LIBUV_INCLUDE_DIRS})
    TARGET_LINK_LIBRARIES(MyTarget PRIVATE ${LIBUV_LIBRARIES})
