#pragma once

#include <iostream>

#include <krlibrary/export.hpp>

namespace krlibrary
{
static inline void inline_hello()
{
    std::cout << "inline_hello" << std::endl;
}

KRLIBRARY_EXPORT
void exported_hello();
} // namespace krlibrary
