# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRDev
    URL https://github.com/JanSimplify/KRDev/archive/refs/tags/v1.0.5.zip
    URL_MD5 29eaa9eb6887d27c08bfbde2d1b0c752
    FIND_PACKAGE_ARGS 1.0.5
)

FetchContent_MakeAvailable(KRDev)
