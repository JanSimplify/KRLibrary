# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

#=============================
# Project
#=============================

project(KRLibrary VERSION 1.0.0 LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds not allowed. "
        "Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

#=============================
# Options
#=============================

include(CMakeDependentOption)

option(
    ${PROJECT_NAME}_ENABLE_INSTALL_SHARED
    "Install shared library"
    "${PROJECT_IS_TOP_LEVEL}"
)

option(
    ${PROJECT_NAME}_ENABLE_INSTALL_STATIC
    "Install static library"
    "${PROJECT_IS_TOP_LEVEL}"
)

option(
    ${PROJECT_NAME}_ENABLE_ADDRESS_SANITIZER
    "Enable address sanitizer"
    OFF
)

cmake_dependent_option(
    ${PROJECT_NAME}_ENABLE_TEST
    "Enalbe test"
    ON
    "${PROJECT_IS_TOP_LEVEL}"
    OFF
)

cmake_dependent_option(
    ${PROJECT_NAME}_DEVELOP_MODE
    "Enalbe develop mode"
    ON
    "${PROJECT_IS_TOP_LEVEL}"
    OFF
)

#=============================
# Dependencies
#=============================

include(cmake/dependencies.cmake)

#=============================
# Variables
#=============================

string(TOLOWER ${PROJECT_NAME} project_name_lowercase)
string(TOUPPER ${PROJECT_NAME} project_name_uppercase)

set(enable_install_shared "${${PROJECT_NAME}_ENABLE_INSTALL_SHARED}")
set(enable_install_static "${${PROJECT_NAME}_ENABLE_INSTALL_STATIC}")
set(enable_test "${${PROJECT_NAME}_ENABLE_TEST}")
set(enable_address_sanitizer "${${PROJECT_NAME}_ENABLE_ADDRESS_SANITIZER}")
set(enable_develop_mode "${PROJECT_NAME}_DEVELOP_MODE")

set(static_target "${PROJECT_NAME}_static")
set(shared_target "${PROJECT_NAME}_shared")

set(static_export "${PROJECT_NAME}StaticExport")
set(shared_export "${PROJECT_NAME}SharedExport")

set(static_output "${project_name_lowercase}")
set(shared_output "${project_name_lowercase}")

if(WIN32)
    string(APPEND static_output "_static")
endif()

set(static_alias "${PROJECT_NAME}::static")
set(shared_alias "${PROJECT_NAME}::shared")
set(library_alias "${PROJECT_NAME}::${PROJECT_NAME}")

set(header_set "${project_name_lowercase}_header_set")

set(autogen_root "${PROJECT_BINARY_DIR}/autogen")

#=============================
# Targets
#=============================

add_library(${static_target} STATIC EXCLUDE_FROM_ALL)
add_library(${shared_target} SHARED EXCLUDE_FROM_ALL)

add_library(${shared_alias} ALIAS ${shared_target})
add_library(${static_alias} ALIAS ${static_target})

if(enable_install_shared)
    set_target_properties(${shared_target} PROPERTIES EXCLUDE_FROM_ALL OFF)
endif()

if(enable_install_static)
    set_target_properties(${static_target} PROPERTIES EXCLUDE_FROM_ALL OFF)
endif()

if(BUILD_SHARED_LIBS)
    add_library(${library_alias} ALIAS ${shared_target})
else()
    add_library(${library_alias} ALIAS ${static_target})
endif()

#=============================
# Sources
#=============================

add_subdirectory(src)

#=============================
# Testing
#=============================

if(enable_test)
    include(CTest)
    if(BUILD_TESTING)
        add_subdirectory(tests)
    endif()
endif()

#=============================
# Packaging
#=============================

if(enable_install_shared OR enable_install_static)
    add_subdirectory(packaging)
endif()
