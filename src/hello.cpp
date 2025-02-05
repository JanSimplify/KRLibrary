#include <krlibrary/hello.hpp>

namespace krlibrary
{
void exported_hello()
{
    std::cout << "exported_hello" << std::endl;
}
} // namespace krlibrary
