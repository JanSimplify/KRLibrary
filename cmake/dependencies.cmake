# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRDev
    URL https://github.com/JanSimplify/KRDev/archive/refs/tags/v1.0.2.zip
    URL_MD5 399cb41aafe3413f07624c3e30714183
)

FetchContent_MakeAvailable(KRDev)
