# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Variables
#=============================

set(autogen_include_dir "${autogen_root}/include")
set(autogen_source_dir "${autogen_root}/src")

set(autogen_export_header "${autogen_include_dir}/${project_name_lowercase}/export.hpp")

set(autogen_version_header "${autogen_include_dir}/${project_name_lowercase}/version.hpp")
set(autogen_version_source "${autogen_source_dir}/version.cpp")

set(headers "${PROJECT_SOURCE_DIR}/include/krlibrary/hello.hpp")
set(sources "hello.cpp")

#=============================
# Export header
#=============================

include(GenerateExportHeader)

generate_export_header(
    ${shared_target}
    BASE_NAME "${PROJECT_NAME}"
    EXPORT_FILE_NAME "${autogen_export_header}"
)

#=============================
# Version file
#=============================

block()
    set(inputs "version.hpp.in" "version.cpp.in")
    set(outputs "${autogen_version_header}" "${autogen_version_source}")

    foreach(in out IN ZIP_LISTS inputs outputs)
        string(JOIN "\n" autogen_notice
            "/**"
            " *  This file is auto-generated from ${in}."
            " *  Do not edit directly."
            " */"
        )
        configure_file(${in} ${out} @ONLY)
    endforeach()
endblock()

#=============================
# Properties
#=============================

set_target_properties(
    ${static_target}
    PROPERTIES
        OUTPUT_NAME "${static_output}"
        EXPORT_NAME "static"
)

set_target_properties(
    ${shared_target}
    PROPERTIES
        OUTPUT_NAME "${shared_output}"
        EXPORT_NAME "shared"
)

foreach(target_name ${static_target} ${shared_target})
    set_target_properties(
        ${target_name}
        PROPERTIES
            VERSION "${PROJECT_VERSION}"
            SOVERSION "${PROJECT_VERSION_MAJOR}"
            CXX_EXTENSIONS OFF
            CXX_VISIBILITY_PRESET "hidden"
            VISIBILITY_INLINES_HIDDEN ON
            LINK_LIBRARIES_ONLY_TARGETS ON
    )
endforeach()

#=============================
# Compile Options
#=============================

include(KRDevCompilerOption)

# for export.hpp
target_compile_definitions(
    ${static_target}
    PUBLIC "${project_name_uppercase}_STATIC_DEFINE"
)

foreach(target_name ${static_target} ${shared_target})
    target_compile_features(
        ${target_name}
        PUBLIC "cxx_std_20"
    )
endforeach()

krdev_targets_set_compile_options(
    TARGETS ${static_target} ${shared_target}
    PRIVATE
        MSVC_OPTIONS
            "/utf-8"
            "/permissive-"
)

if(enable_address_sanitizer)
    krdev_targets_set_sanitizer(
        TARGETS ${static_target} ${shared_target}
        ADDRESS
    )
endif()

if(enable_coverage_analysis)
    krdev_targets_set_coverage(
        TARGETS ${static_target} ${shared_target}
    )
endif()

if(enable_develop_mode)
    krdev_targets_set_development_options(
        TARGETS ${static_target} ${shared_target}
        ERROR_AS_FATAL
    )
endif()

#=============================
# Source files
#=============================

foreach(target ${static_target} ${shared_target})
    target_sources(
        ${target}
        PUBLIC
            FILE_SET ${header_set}
            TYPE HEADERS
            BASE_DIRS
                "${autogen_include_dir}"
            FILES
                "${autogen_export_header}"
                "${autogen_version_header}"
        PRIVATE
            "${autogen_version_source}"
            "${sources}"
    )

    if(headers)
        target_sources(
            ${target}
            PUBLIC
                FILE_SET ${header_set}
                TYPE HEADERS
                BASE_DIRS
                    "${PROJECT_SOURCE_DIR}/include"
                FILES
                    "${headers}"
        )
    endif()
endforeach()
