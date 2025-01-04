# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRDev
    GIT_REPOSITORY https://github.com/JanSimplify/KRDev.git
    GIT_TAG main
    SYSTEM
    GIT_SHALLOW
)

FetchContent_MakeAvailable(KRDev)
