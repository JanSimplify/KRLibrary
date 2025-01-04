# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

block()
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(BUILD_SHARED_LIBS OFF)

    if(MSVC AND enable_address_sanitizer)
        list(APPEND CMAKE_C_FLAGS /fsanitize=address)
        list(APPEND CMAKE_CXX_FLAGS /fsanitize=address)
    endif()

    FetchContent_Declare(
        Catch2
        URL https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.1.zip
    )

    FetchContent_MakeAvailable(Catch2)

    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endblock()

FetchContent_Declare(
    KRDev
    GIT_REPOSITORY https://github.com/JanSimplify/KRDev.git
    GIT_TAG main
    SYSTEM
    GIT_SHALLOW
)

FetchContent_MakeAvailable(KRDev)
