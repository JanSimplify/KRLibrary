# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

set(package_name KRLibrary)
set(package_library_target KRLibrary::KRLibrary)

project(${package_name}Test)

#=============================
# Options
#=============================

option(
    ${package_name}_ENABLE_ADDRESS_SANITIZER
    "Enable address sanitizer"
    OFF
)

#=============================
# Dependencies
#=============================

if(PROJECT_IS_TOP_LEVEL)
    include(CTest)
    find_package(${package_name} REQUIRED)
endif()

include(cmake/dependencies.cmake)

#=============================
# Variables
#=============================

string(TOLOWER ${PROJECT_NAME} project_name_lowercase)

set(enable_address_sanitizer ${${package_name}_ENABLE_ADDRESS_SANITIZER})

set(test_target ${PROJECT_NAME})
set(test_output ${project_name_lowercase})

set(test_header_set "${project_name_lowercase}_header_set")

set(test_headers "")

set(test_sources
    "${CMAKE_CURRENT_LIST_DIR}/main.cpp"
)

#=============================
# Targets
#=============================

add_executable(${test_target})

target_link_libraries(
    ${test_target} 
    PRIVATE
        ${package_library_target}
        Catch2::Catch2WithMain
)

#=============================
# Properties
#=============================

set_target_properties(
    ${test_target}
    PROPERTIES
        OUTPUT_NAME ${test_output}
        CXX_EXTENSIONS OFF
        LINK_LIBRARIES_ONLY_TARGETS ON
)

#=============================
# Compile Options
#=============================

include(KRDevCompilerOption)

target_compile_features(
    ${test_target}
    PRIVATE "cxx_std_20"
)

krdev_targets_set_compile_options(
    TARGETS ${test_target}
    PRIVATE
        MSVC_OPTIONS
            "/utf-8"
            "/permissive-"
)

if(enable_address_sanitizer)
    krdev_targets_set_sanitizer(
        TARGETS ${test_target}
        ADDRESS
    )
endif()

krdev_targets_set_development_options(
    TARGETS ${test_target}
    ERROR_AS_FATAL
)

#=============================
# Source files
#=============================

target_sources(
    ${test_target}
    PRIVATE
        ${test_sources}
)

if(test_headers)
    target_sources(
        ${test_target}
        PRIVATE
            FILE_SET ${test_header_set}
            TYPE HEADERS
            BASE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include"
            FILES ${test_headers}
    )
endif()

#=============================
# Testing
#=============================

include(Catch)

catch_discover_tests(
    ${test_target}
    DL_PATHS $<TARGET_FILE_DIR:${package_library_target}>
)
