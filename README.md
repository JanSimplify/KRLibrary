[![CMake on multiple platforms](https://github.com/JanSimplify/KRLibrary/actions/workflows/cmake-multi-platform.yml/badge.svg)](https://github.com/JanSimplify/KRLibrary/actions/workflows/cmake-multi-platform.yml)

# KRLibrary

CMake C++20 跨平台库项目脚手架，支持：

- 生成和安装动态库与静态库；
- 自动生成版本信息函数；
- 禁止动态库默认导出符号，使用辅助宏手动控制符号导出；
- 开发者模式下的启用编译警告选项；
- 支持安装，支持通过`find_package()`添加；
- 使用`Catch2`测试框架。

测试于：

- Ubuntu：GCC，Clang；
- Windows：MSVC。

## 功能演示

### 配置选项

是否启用对动态库和静态库的安装，作为顶层项目构建时默认都开启，作为子项目时默认都关闭：

```cmake
KRLibrary_ENABLE_INSTALL_SHARED
KRLibrary_ENABLE_INSTALL_STATIC
```

[BUILD_SHARED_LIBS](https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html)是CMake官方文档中记录的变量，为真时别名`KRLibrary::KRLibrary`指向动态库，否则指向静态库：

```cmake
BUILD_SHARED_LIBS
```

[BUILD_TESTING](https://cmake.org/cmake/help/git-stage/variable/BUILD_TESTING.html)是CMake官方文档中记录的变量，与`KRLibrary_ENABLE_TEST`共同决定是否启用测试代码的编译：

```cmake
KRLibrary_ENABLE_TEST
BUILD_TESTING
```

是否启用`address sanitizer`进行构建，默认关闭，主要供MSVC使用，MSVC中静态链接时需要保证各个库的`address sanitizer`选项一致，否则会导致链接错误：

```cmake
KRLibrary_ENABLE_ADDRESS_SANITIZER
```

是否启用编译器警告选项，作为顶层项目构建时默认开启，作为子项目时默认关闭：

```cmake
KRLibrary_DEVELOP_MODE
```

是否对测试代码启用`address sanitizer`，注意与`KRLibrary_ENABLE_ADDRESS_SANITIZER`保持一致：

```cmake
KRLibraryTest_ENABLE_ADDRESS_SANITIZER	
```

### 编译与安装

克隆项目并进入目录：

```bash
$ git clone https://github.com/JanSimplify/KRLibrary.git --depth=1
$ cd KRLibrary
```

使用cmake构建项目，这里为了方便，关闭了对测试代码的编译：

```bash
$ cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DKRLibrary_ENABLE_TEST=OFF
```

编译项目：

```bash
$ cmake --build build
```

安装项目，使用`--prefix`指定安装的根目录，这里仅用作演示，实践中请自行选择合适的目录：

```bash
$ cmake --install build --config Release --prefix install/
-- Installing: /home/kr/KRLibrary/install/lib/cmake/KRLibrary/KRLibraryConfig.cmake
-- Installing: /home/kr/KRLibrary/install/lib/cmake/KRLibrary/KRLibraryConfigVersion.cmake
-- Installing: /home/kr/KRLibrary/install/lib/libkrlibrary.so.1.0.0
# ...
```

### 使用

如果希望在应用项目中使用库，有两种方法：

- 使用`find_package()`，适用于已安装库的情况；
- 使用`fetch_content()`，适用于希望项目独立拉取库代码共同编译的情况。

对于使用已安装库的情况，在应用项目中添加如下语句添加库：

```cmake
find_package(KRLibrary REQUIRED)
```

通常不会将非系统库安装至系统搜索目录，因此配置时需要为CMake指定额外的搜索路径：

```bash
$ cmake -S <app_dir> -B <app_build> -DCMAKE_PREFIX_PATH=<lib_install_root>
```

如果希望独立拉取并编译库代码，则应当使用`fetch_content()`：

```cmake
include(FetchContent)

FetchContent_Declare(
    KRLibrary
    GIT_REPOSITORY https://github.com/JanSimplify/KRLibrary.git
    GIT_TAG main
    SYSTEM
    GIT_SHALLOW
)

FetchContent_MakeAvailable(KRLibrary)
```

完成导入后，应用项目可以链接至动态库或静态库：

```cmake
target_link_libraries(<app1> PRIVATE KRLibrary::static)
target_link_libraries(<app2> PRIVATE KRLibrary::shared)
```

也可以使用非指定版本，它的行为受到CMake变量`BUILD_SHARED_LIBS`的控制：

```cmake
# BUILD_SHARED_LIBS为TRUE时指向动态库，反之指向静态库
target_link_libraries(<app> PRIVATE KRLibrary::KRLibrary)
```

### 控制安装行为

如果只希望分发动态库，而不希望安装头文件、静态库等开发者才会使用的文件，可以在安装时指定组件`KRLibrary_Runtime`：

```bash
$ cmake --install build/ --prefix install/ --component KRLibrary_Runtime
-- Install configuration: "Release"
-- Up-to-date: /home/kr/KRLibrary/install/lib/libkrlibrary.so.1.0.0
-- Up-to-date: /home/kr/KRLibrary/install/lib/libkrlibrary.so.1
```

如果希望安装头文件、动态库和`cmake`配置文件，但不希望安装静态库，可以在配置阶段进行指定：

```bash
$ cmake -S . -B build/ -DKRLibrary_ENABLE_INSTALL_STATIC=OFF
```

如下选项控制动态库与静态库的安装：

```bash
KRLibrary_ENABLE_INSTALL_SHARED
KRLibrary_ENABLE_INSTALL_STATIC
```

当项目作为顶层项目进行构建时，两个选项均默认开启，而在作为其他项目的子模块时默认关闭，两种情况下都可以通过修改选项手动控制。

### 测试

默认集成`Catch2`测试框架，作为顶层项目构建时默认启用，也可以通过选项开启：

```bash
$ cmake -S . -B build -DKRLibrary_ENABLE_TEST=ON
$ cmake --build build
```

切换工作目录并使用`ctest`运行测试：

```bash
$ cd build
$ ctest
Test project /home/kr/KRLibrary/build
    Start 1: always success
1/1 Test #1: always success ...................   Passed    0.03 sec

100% tests passed, 0 tests failed out of 1

Total Test time (real) =   0.04 sec
```

注意不要手动直接运行测试的可执行程序，因为`ctest`会配置必要的环境变量，缺乏这些变量可能会导致找不到动态库之类的错误。

### 开发者选项

如下选项提供对库构建过程的控制，它们的名称受到项目名称的影响：

```cmake
KRLibrary_DEVELOP_MODE # 开发者模式，启用一系列编译器警告选项
KRLibrary_ENABLE_ADDRESS_SANITIZER # 是否启用address sanitizer
```

`KRLibrary_DEVELOP_MODE`在作为顶层构建时默认启用，作为子项目时关闭并隐藏选项，库内部的警告信息不应当传播到库的使用者一方。

`KRLibrary_ENABLE_ADDRESS_SANITIZER`主要针对MSVC，静态链接多个对象时，如果`sanitizer`选项不一致，会导致链接错误，其他编译器不需要使用个这个选项。

## 修改模板

将`LICENSE`替换为你自己的许可证协议：

```LICENSE
<Your License>

Copyright (c) <year> <owner>

<License text>
```

搜索并替换文件中的协议与版权声明，这里仅演示如何使用`grep`进行搜索：

```bash
$ grep -rn 'SPDX' --exclude-dir={build,.git} --exclude=README.md
cmake/dependencies.cmake:1:# SPDX-License-Identifier: MIT-0
cmake/dependencies.cmake:2:# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify
# ...
```

搜索并替换项目名称，这里仅演示如何使用`grep`进行搜索：

```bash
$ grep -irn 'KRLibrary' --exclude-dir={build,.git} --exclude=README.md
CMakeLists.txt:10:project(KRLibrary VERSION 1.0.0 LANGUAGES CXX)
tests/CMakeLists.txt:6:project(KRLibraryTest)
# ...
```

其余选项、变量名称、自动生成的头文件等均会自动应用新的项目名称。修改完毕后，如果存在旧的构建目录，建议先删除后再重新构建。
