# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

block()
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(BUILD_SHARED_LIBS OFF)

    if(MSVC AND ${PROJECT_NAME}_ENABLE_ADDRESS_SANITIZER)
        list(APPEND CMAKE_C_FLAGS /fsanitize=address)
        list(APPEND CMAKE_CXX_FLAGS /fsanitize=address)
    endif()

    FetchContent_Declare(
        Catch2
        URL https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.1.zip
        URL_MD5 571bc82764d0104caf038d2cfd271c1c
    )

    FetchContent_MakeAvailable(Catch2)

    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endblock()

FetchContent_Declare(
    KRDev
    URL https://github.com/JanSimplify/KRDev/archive/refs/tags/v1.0.2.zip
    URL_MD5 399cb41aafe3413f07624c3e30714183
)

FetchContent_MakeAvailable(KRDev)
