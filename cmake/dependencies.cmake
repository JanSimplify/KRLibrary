# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRDev
    URL https://github.com/JanSimplify/KRDev/archive/refs/tags/v1.0.4.zip
    URL_MD5 530422dae2bdc8e99e5f5d646a3d4ab8
    FIND_PACKAGE_ARGS 1.0.4
)

FetchContent_MakeAvailable(KRDev)
