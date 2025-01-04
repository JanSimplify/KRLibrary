// SPDX-License-Identifier: MIT-0
// SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#include <catch2/catch_test_macros.hpp>

#include <iostream>

#include <krlibrary/version.hpp>

TEST_CASE("always success", "[krlibrary]")
{
    std::cout << krlibrary::version() << std::endl;
    REQUIRE(true);
}
