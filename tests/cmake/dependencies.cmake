# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

block()
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(BUILD_SHARED_LIBS OFF)

    if(${PROJECT_NAME}_ENABLE_ADDRESS_SANITIZER)
        add_compile_options(
            $<$<OR:$<COMPILE_LANG_AND_ID:C,MSVC>,$<COMPILE_LANG_AND_ID:CXX,MSVC>>:/fsanitize=address>
        )
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
    URL https://github.com/JanSimplify/KRDev/archive/refs/tags/v1.0.4.zip
    URL_MD5 530422dae2bdc8e99e5f5d646a3d4ab8
    FIND_PACKAGE_ARGS 1.0.4
)

FetchContent_MakeAvailable(KRDev)
